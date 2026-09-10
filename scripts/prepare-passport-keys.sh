#!/bin/sh
set -eu

umask 077

source_path="${PASSPORT_KEY_SOURCE_PATH:-/workspace/services/api/storage}"
target_path="${PASSPORT_KEY_PATH:-/var/lib/materyalph/passport}"

for filename in oauth-private.key oauth-public.key; do
    source_file="${source_path}/${filename}"
    if [ ! -f "$source_file" ] || [ ! -s "$source_file" ] || [ ! -r "$source_file" ]; then
        echo "Passport key preparation failed: a required source key is unavailable." >&2
        exit 1
    fi
done

mkdir -p "$target_path"
chmod 700 "$target_path"

private_temp="$(mktemp "${target_path}/.oauth-private.key.XXXXXX")"
public_temp="$(mktemp "${target_path}/.oauth-public.key.XXXXXX")"
cleanup() {
    rm -f "$private_temp" "$public_temp"
}
trap cleanup EXIT HUP INT TERM

cp "${source_path}/oauth-private.key" "$private_temp"
cp "${source_path}/oauth-public.key" "$public_temp"
chmod 600 "$private_temp" "$public_temp"

cmp -s "${source_path}/oauth-private.key" "$private_temp"
cmp -s "${source_path}/oauth-public.key" "$public_temp"

mv -f "$private_temp" "${target_path}/oauth-private.key"
mv -f "$public_temp" "${target_path}/oauth-public.key"
chmod 600 "${target_path}/oauth-private.key" "${target_path}/oauth-public.key"

cmp -s "${source_path}/oauth-private.key" "${target_path}/oauth-private.key"
cmp -s "${source_path}/oauth-public.key" "${target_path}/oauth-public.key"

[ "$(stat -c '%a' "${target_path}/oauth-private.key")" = '600' ]
[ "$(stat -c '%a' "${target_path}/oauth-public.key")" = '600' ]

echo "Passport keys were prepared in protected runtime storage."
