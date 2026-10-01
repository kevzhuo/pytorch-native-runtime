#!/bin/sh
set -eu

# GitHub can rate-limit the shared image-builder IP partway through the
# submodule checkout. Retry in place so already fetched revisions are reused.
retry() {
    attempt=1
    delay=15
    while true; do
        if "$@"; then
            return 0
        else
            status=$?
        fi
        if [ "$attempt" -ge 5 ]; then
            printf 'Source fetch failed after %s attempts\n' "$attempt" >&2
            return "$status"
        fi
        printf 'Source fetch attempt %s failed; retrying in %ss\n' "$attempt" "$delay" >&2
        sleep "$delay"
        attempt=$((attempt + 1))
        delay=$((delay * 2))
        if [ "$delay" -gt 60 ]; then
            delay=60
        fi
    done
}

base_commit=${1:?Pass the pinned PyTorch base commit}
git init .
git remote add origin https://github.com/pytorch/pytorch.git
retry git fetch --depth=1 origin "$base_commit"
git checkout --detach FETCH_HEAD
retry git submodule update --init --recursive --force --depth=1 --jobs=1
python /tmp/verify_source.py "$base_commit"
