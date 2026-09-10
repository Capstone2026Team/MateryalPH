<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Identity\AuthenticationException;
use App\Domain\Identity\BotProtectionService;
use App\Models\BotRiskChallenge;
use Illuminate\Foundation\Testing\DatabaseMigrations;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Tests\TestCase;

final class BotProofConcurrencyTest extends TestCase
{
    use DatabaseMigrations;

    public function test_only_one_concurrent_consumer_can_use_a_risk_proof(): void
    {
        if (! function_exists('pcntl_fork')) {
            self::markTestSkipped('The concurrent proof test requires pcntl.');
        }

        $email = 'concurrent-buyer@example.test';
        $proof = 'single-use-concurrent-proof';
        $challenge = BotRiskChallenge::query()->create([
            'normalized_email_hash' => hash_hmac('sha256', $email, (string) config('app.key')),
            'portal' => 'BUYER',
            'action' => 'buyer_login',
            'platform' => 'WEB',
            'outcome' => 'LOW_SCORE',
            'delivery_allowed' => true,
            'expires_at' => now()->addMinutes(5),
            'verified_at' => now(),
            'proof_expires_at' => now()->addMinutes(5),
            'proof_hash' => hash_hmac('sha256', $proof, (string) config('app.key')),
        ]);

        $prefix = sys_get_temp_dir().DIRECTORY_SEPARATOR.'materyalph-proof-race-'.Str::uuid7();
        $start = $prefix.'-start';
        $results = [$prefix.'-one.json', $prefix.'-two.json'];
        $children = [];
        DB::disconnect();

        try {
            foreach ($results as $resultPath) {
                $pid = pcntl_fork();
                self::assertNotSame(-1, $pid, 'The proof-consumption worker could not be started.');
                if ($pid === 0) {
                    $this->runProofConsumer($start, $resultPath, $email, $proof);
                }
                $children[] = $pid;
            }

            file_put_contents($start, 'go');
            foreach ($children as $child) {
                pcntl_waitpid($child, $status);
                self::assertTrue(pcntl_wifexited($status));
                self::assertSame(0, pcntl_wexitstatus($status));
            }

            $outcomes = array_map(
                static fn (string $path): array => json_decode((string) file_get_contents($path), true, flags: JSON_THROW_ON_ERROR),
                $results,
            );
            self::assertCount(1, array_filter($outcomes, static fn (array $outcome): bool => ($outcome['ok'] ?? false) === true));
            self::assertCount(1, array_filter($outcomes, static fn (array $outcome): bool => ($outcome['code'] ?? null) === 'BOT_STEP_UP_INVALID'));

            DB::reconnect();
            self::assertNotNull(BotRiskChallenge::query()->findOrFail($challenge->getKey())->consumed_at);
        } finally {
            foreach ([$start, ...$results] as $path) {
                if (is_file($path)) {
                    unlink($path);
                }
            }
            DB::reconnect();
        }
    }

    private function runProofConsumer(string $start, string $resultPath, string $email, string $proof): never
    {
        $deadline = microtime(true) + 10;
        while (! is_file($start) && microtime(true) < $deadline) {
            usleep(1_000);
        }

        DB::purge();
        DB::reconnect();
        $request = Request::create('/api/v1/auth/login', 'POST');
        $request->attributes->set('correlation_id', (string) Str::uuid7());

        try {
            app(BotProtectionService::class)->guard(
                $request,
                $email,
                'BUYER',
                'LOGIN',
                null,
                $proof,
                true,
            );
            $outcome = ['ok' => true];
        } catch (AuthenticationException $exception) {
            $outcome = ['ok' => false, 'code' => $exception->errorCode];
        } catch (\Throwable $exception) {
            $outcome = ['ok' => false, 'code' => $exception::class];
        }

        file_put_contents($resultPath, json_encode($outcome, JSON_THROW_ON_ERROR));
        exit(0);
    }
}
