# Local test-environment incident

Phase 1 remains unaccepted until every recovery-plan gate passes.

During the September 9, 2026 continuation, the first Docker backend test runs
used `docker compose exec -T api php artisan test` without overriding inherited
runtime environment variables. The existing PHPUnit environment declarations did
not override the effective container configuration. Database-refresh tests ran
against the development database, which may have removed existing local records.
The later isolated test and migration successes are not evidence of recovery.

A subsequent database-free test, protected by a new pre-migration guard, confirmed
that the unqualified command loads a non-testing environment, a non-test database,
and a non-array cache. Further database-changing work was stopped upon confirming
this. No backup recovery has been performed or verified.

The development database was subsequently confirmed to contain no user-created
records and no external backup exists. Its Docker VHDX is intentionally retained
in place, but recovery is unnecessary. It must remain untouched until the isolated
test guard passes.

## Isolation design

- Automated database checks run only in the standalone
  `materyalph_phase1_test` Compose project. It has separate containers, network,
  named volumes, database, and `materyalph_test_runner` role.
- The shared test base and schema verifier reject non-testing, cached, URL-based,
  incomplete, development-host, or parallel configuration before refresh traits
  or migration commands can run.
- Both guards query the live connection and require PostgreSQL 16,
  `materyalph_test`, and `materyalph_test_runner`.
- The runner proves negative cases against a disposable sentinel before it starts
  any application test:

```powershell
./scripts/run-tests-isolated.ps1 -GuardOnly
```

Only after that command succeeds may the same runner rebuild the isolated test
schema and execute automated tests. Rebuilding the empty development database is
the final local-operational step, never part of automated testing.
