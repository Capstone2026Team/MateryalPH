#!/bin/sh
set -eu

source_path="${PASSPORT_KEY_SOURCE_PATH:-/workspace/services/api/storage}"
temporary_root="$(mktemp -d)"
target_path="${temporary_root}/runtime"
cleanup() {
    rm -rf "$temporary_root"
}
trap cleanup EXIT HUP INT TERM

if PASSPORT_KEY_SOURCE_PATH="${temporary_root}/missing" PASSPORT_KEY_PATH="${temporary_root}/missing-runtime" \
    sh /workspace/scripts/prepare-passport-keys.sh >/dev/null 2>&1; then
    echo "Passport key preparation regression failed: missing source keys were accepted." >&2
    exit 1
fi

PASSPORT_KEY_SOURCE_PATH="$source_path" PASSPORT_KEY_PATH="$target_path" \
    sh /workspace/scripts/prepare-passport-keys.sh >/dev/null

cmp -s "${source_path}/oauth-private.key" "${target_path}/oauth-private.key"
cmp -s "${source_path}/oauth-public.key" "${target_path}/oauth-public.key"

PASSPORT_KEY_PATH="$target_path" php /workspace/scripts/verify-passport-keys.php >/dev/null

chmod 777 "${target_path}/oauth-private.key"
if PASSPORT_KEY_PATH="$target_path" php /workspace/scripts/verify-passport-keys.php >/dev/null 2>&1; then
    echo "Passport key preparation regression failed: insecure permissions were accepted." >&2
    exit 1
fi

cmp -s "${source_path}/oauth-private.key" "${target_path}/oauth-private.key"
cmp -s "${source_path}/oauth-public.key" "${target_path}/oauth-public.key"

echo "Passport key preparation regression passed."
