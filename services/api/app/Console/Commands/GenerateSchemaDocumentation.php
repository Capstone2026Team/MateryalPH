<?php

declare(strict_types=1);

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\File;
use stdClass;

final class GenerateSchemaDocumentation extends Command
{
    protected $signature = 'materyalph:schema-document {--check : Fail when generated files differ from the working tree}';

    protected $description = 'Generate the ERD and data dictionary from the migrated PostgreSQL schema';

    public function handle(): int
    {
        if (DB::getDriverName() !== 'pgsql') {
            $this->components->error('Schema documentation requires the authoritative PostgreSQL schema.');

            return self::FAILURE;
        }

        if (DB::table('migrations')->count() !== count(File::files(database_path('migrations')))) {
            $this->components->error('Apply every migration before generating schema documentation.');

            return self::FAILURE;
        }

        $columns = DB::select(<<<'SQL'
            SELECT c.table_name, c.ordinal_position, c.column_name,
                   CASE WHEN c.data_type = 'USER-DEFINED' THEN c.udt_name ELSE c.data_type END AS data_type,
                   c.is_nullable, c.column_default,
                   EXISTS (
                       SELECT 1
                       FROM information_schema.table_constraints tc
                       JOIN information_schema.key_column_usage kcu
                         ON kcu.constraint_name = tc.constraint_name AND kcu.constraint_schema = tc.constraint_schema
                       WHERE tc.table_schema = 'public' AND tc.constraint_type = 'PRIMARY KEY'
                         AND tc.table_name = c.table_name AND kcu.column_name = c.column_name
                   ) AS is_primary
            FROM information_schema.columns c
            WHERE c.table_schema = 'public'
            ORDER BY c.table_name, c.ordinal_position
            SQL);
        $constraints = DB::select(<<<'SQL'
            SELECT child.relname AS table_name, con.conname AS constraint_name,
                   CASE con.contype WHEN 'f' THEN 'FOREIGN KEY' WHEN 'u' THEN 'UNIQUE'
                        WHEN 'p' THEN 'PRIMARY KEY' WHEN 'c' THEN 'CHECK' ELSE con.contype::text END AS constraint_type,
                   pg_get_constraintdef(con.oid, true) AS definition
            FROM pg_constraint con
            JOIN pg_class child ON child.oid = con.conrelid
            JOIN pg_namespace ns ON ns.oid = child.relnamespace
            WHERE ns.nspname = 'public'
            ORDER BY child.relname, constraint_type, con.conname
            SQL);
        $indexes = DB::select(<<<'SQL'
            SELECT tablename AS table_name, indexname AS index_name, indexdef AS definition
            FROM pg_indexes
            WHERE schemaname = 'public'
            ORDER BY tablename, indexname
            SQL);
        $foreignKeys = DB::select(<<<'SQL'
            SELECT child.relname AS child_table, child_col.attname AS child_column,
                   parent.relname AS parent_table, parent_col.attname AS parent_column,
                   NOT child_col.attnotnull AS is_nullable
            FROM pg_constraint con
            JOIN pg_class child ON child.oid = con.conrelid
            JOIN pg_class parent ON parent.oid = con.confrelid
            JOIN pg_namespace ns ON ns.oid = child.relnamespace
            JOIN LATERAL unnest(con.conkey) WITH ORDINALITY child_key(attnum, ord) ON true
            JOIN LATERAL unnest(con.confkey) WITH ORDINALITY parent_key(attnum, ord) ON parent_key.ord = child_key.ord
            JOIN pg_attribute child_col ON child_col.attrelid = child.oid AND child_col.attnum = child_key.attnum
            JOIN pg_attribute parent_col ON parent_col.attrelid = parent.oid AND parent_col.attnum = parent_key.attnum
            WHERE ns.nspname = 'public' AND con.contype = 'f'
            ORDER BY parent.relname, child.relname, con.conname, child_key.ord
            SQL);

        $dictionary = $this->dictionary($columns, $constraints, $indexes);
        $erd = $this->erd($columns, $foreignKeys);
        $directory = base_path('../../docs/architecture');
        $targets = [
            $directory.'/data-dictionary.md' => $dictionary,
            $directory.'/erd.md' => $erd,
        ];

        if ($this->option('check')) {
            foreach ($targets as $path => $content) {
                if (! File::exists($path) || File::get($path) !== $content) {
                    $this->components->error('Generated schema documentation is stale: '.$path);

                    return self::FAILURE;
                }
            }

            $this->components->info('Schema documentation matches the migrated database.');

            return self::SUCCESS;
        }

        File::ensureDirectoryExists($directory);
        foreach ($targets as $path => $content) {
            File::put($path, $content);
        }
        $this->components->info('Generated docs/architecture/erd.md and data-dictionary.md from PostgreSQL.');

        return self::SUCCESS;
    }

    /**
     * @param  list<stdClass>  $columns
     * @param  list<stdClass>  $constraints
     * @param  list<stdClass>  $indexes
     */
    private function dictionary(array $columns, array $constraints, array $indexes): string
    {
        /** @var array<string, list<stdClass>> $columnsByTable */
        $columnsByTable = [];
        foreach ($columns as $column) {
            $columnsByTable[(string) $column->table_name][] = $column;
        }

        $lines = [
            '# MateryalPH Data Dictionary',
            '',
            '> Generated by `php artisan materyalph:schema-document` from the fully migrated PostgreSQL `public` schema. Do not edit generated table definitions by hand.',
            '',
            'All `*_centavos` columns store integer Philippine centavos. All `timestamp with time zone` values are persisted in UTC and business deadlines are rendered in Asia/Manila.',
            '',
        ];
        foreach ($columnsByTable as $table => $tableColumns) {
            $lines[] = '## `'.$table.'`';
            $lines[] = '';
            $lines[] = $this->purpose($table);
            $lines[] = '';
            $lines[] = '| Column | Database type | Null | Default | Key / meaning |';
            $lines[] = '| --- | --- | --- | --- | --- |';
            foreach ($tableColumns as $column) {
                $columnName = (string) $column->column_name;
                $meaning = ((bool) $column->is_primary ? 'Primary key. ' : '')
                    .(str_ends_with($columnName, '_centavos') ? 'Integer Philippine centavos. ' : '')
                    .$this->humanize($columnName).'.';
                $lines[] = sprintf(
                    '| `%s` | `%s` | %s | %s | %s |',
                    $columnName,
                    $this->cell((string) $column->data_type),
                    $column->is_nullable === 'YES' ? 'Yes' : 'No',
                    $column->column_default === null ? '—' : '`'.$this->cell((string) $column->column_default).'`',
                    $this->cell($meaning),
                );
            }
            $tableConstraints = array_values(array_filter($constraints, fn (stdClass $constraint): bool => $constraint->table_name === $table));
            $tableIndexes = array_values(array_filter($indexes, fn (stdClass $index): bool => $index->table_name === $table));
            $lines[] = '';
            $lines[] = '**Constraints**';
            $lines[] = '';
            foreach ($tableConstraints as $constraint) {
                $lines[] = '- `'.$constraint->constraint_name.'` — '.$constraint->constraint_type.': `'.$this->inline((string) $constraint->definition).'`';
            }
            $lines[] = '';
            $lines[] = '**Indexes**';
            $lines[] = '';
            foreach ($tableIndexes as $index) {
                $lines[] = '- `'.$index->index_name.'` — `'.$this->inline((string) $index->definition).'`';
            }
            $lines[] = '';
        }

        return implode("\n", $lines)."\n";
    }

    /**
     * @param  list<stdClass>  $columns
     * @param  list<stdClass>  $foreignKeys
     */
    private function erd(array $columns, array $foreignKeys): string
    {
        $tables = array_values(array_unique(array_map(fn (stdClass $column): string => (string) $column->table_name, $columns)));
        $lines = [
            '# MateryalPH Entity-Relationship Diagram',
            '',
            '> Generated by `php artisan materyalph:schema-document` from the fully migrated PostgreSQL `public` schema. Relationships below are actual foreign keys; optionality reflects the child column nullability.',
            '',
            '```mermaid',
            'erDiagram',
        ];
        foreach ($tables as $table) {
            $lines[] = '    '.$this->mermaidName($table).' {';
            foreach (array_filter($columns, fn (stdClass $column): bool => $column->table_name === $table && (bool) $column->is_primary) as $primary) {
                $lines[] = '        '.$this->mermaidType((string) $primary->data_type).' '.$primary->column_name.' PK';
            }
            $lines[] = '    }';
        }
        foreach ($foreignKeys as $foreignKey) {
            $childCardinality = (bool) $foreignKey->is_nullable ? 'o{' : '|{';
            $lines[] = sprintf(
                '    %s ||--%s %s : "%s → %s"',
                $this->mermaidName((string) $foreignKey->parent_table),
                $childCardinality,
                $this->mermaidName((string) $foreignKey->child_table),
                $foreignKey->child_column,
                $foreignKey->parent_column,
            );
        }
        $lines[] = '```';
        $lines[] = '';
        $lines[] = 'The diagram intentionally shows database ownership and referential integrity, not application workflow transitions. FIN and MAT state transitions remain defined in the approved workflows and enforced by domain services plus database checks.';

        return implode("\n", $lines)."\n";
    }

    private function purpose(string $table): string
    {
        return match (true) {
            str_starts_with($table, 'oauth_'), str_contains($table, 'auth_'), str_contains($table, 'otp'), str_contains($table, 'identity') => 'Identity and secure-session record.',
            str_starts_with($table, 'vendor_'), str_starts_with($table, 'store_') => 'Vendor organization, access, onboarding, or storefront record.',
            str_starts_with($table, 'buyer_') => 'Buyer identity, profile, or saved-context record.',
            str_starts_with($table, 'financial_'), str_starts_with($table, 'fee_'), str_starts_with($table, 'tax_'), str_starts_with($table, 'remittance_'), str_contains($table, 'invoice') => 'FIN-01–FIN-12 financial control and evidence record.',
            str_contains($table, 'analytics'), str_contains($table, 'price_observation'), str_contains($table, 'comparable') => 'MAT-01–MAT-07 comparability, observation, publication, or audience-safe aggregate record.',
            str_contains($table, 'payment'), str_contains($table, 'refund') => 'Payment, refund, or physical-money evidence record with an independent lifecycle.',
            str_contains($table, 'order'), str_contains($table, 'quotation'), str_contains($table, 'work_package') => 'Procurement or immutable commerce record.',
            default => 'Phase 1 platform foundation record.',
        };
    }

    private function humanize(string $value): string
    {
        return ucfirst(str_replace('_', ' ', $value));
    }

    private function cell(string $value): string
    {
        return str_replace(['|', "\r", "\n"], ['\\|', ' ', ' '], $value);
    }

    private function inline(string $value): string
    {
        return str_replace(['`', "\r", "\n"], ["'", ' ', ' '], $value);
    }

    private function mermaidName(string $value): string
    {
        return strtoupper(preg_replace('/[^a-zA-Z0-9_]/', '_', $value) ?? $value);
    }

    private function mermaidType(string $value): string
    {
        return preg_replace('/[^a-zA-Z0-9_]/', '_', $value) ?? 'value';
    }
}
