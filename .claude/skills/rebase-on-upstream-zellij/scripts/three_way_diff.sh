#!/usr/bin/env bash
# Three-way diff helper for rebasing zellij-tab-bar-indexed onto a new upstream tag.
#
# Usage:
#   three_way_diff.sh <old_tag> <new_tag>
#
# Example:
#   three_way_diff.sh v0.44.0 v0.44.3
#
# Produces under /tmp/zellij-rebase-<new_tag>/:
#   v<old_tag>/                                upstream clone at the previous base
#   v<new_tag>/                                upstream clone at the new target
#   fork-tab-bar.patch       diff old-upstream vs current local fork (= canonical fork patches)
#   fork-compact-bar.patch
#   upstream-tab-bar.patch   diff old-upstream vs new-upstream (= what upstream changed)
#   upstream-compact-bar.patch
#
# Read these to know exactly which fork-customizations to reapply on top of the
# upstream snapshot, and which upstream fixes you are inheriting for free.

set -euo pipefail

if [ $# -ne 2 ]; then
    echo "Usage: $0 <old_tag> <new_tag>" >&2
    echo "Example: $0 v0.44.0 v0.44.3" >&2
    exit 2
fi

OLD_TAG="$1"
NEW_TAG="$2"
WORKDIR="/tmp/zellij-rebase-${NEW_TAG}"
REPO_ROOT="$(git rev-parse --show-toplevel)"

mkdir -p "$WORKDIR"

for tag in "$OLD_TAG" "$NEW_TAG"; do
    target="$WORKDIR/$tag"
    if [ ! -d "$target/default-plugins" ]; then
        echo "Cloning zellij $tag into $target ..."
        rm -rf "$target"
        git clone --depth 1 --branch "$tag" \
            https://github.com/zellij-org/zellij.git "$target"
    else
        echo "Reusing existing clone $target"
    fi
done

cd "$REPO_ROOT"

for plugin in tab-bar compact-bar; do
    diff -ruN \
        "$WORKDIR/$OLD_TAG/default-plugins/$plugin/src" \
        "$plugin/src" \
        > "$WORKDIR/fork-${plugin}.patch" || true

    diff -ruN \
        "$WORKDIR/$OLD_TAG/default-plugins/$plugin/src" \
        "$WORKDIR/$NEW_TAG/default-plugins/$plugin/src" \
        > "$WORKDIR/upstream-${plugin}.patch" || true
done

echo
echo "Generated patches in $WORKDIR:"
ls -la "$WORKDIR"/*.patch | awk '{printf "  %s  (%s lines)\n", $NF, $5}'
echo
echo "Inspect:"
echo "  cat $WORKDIR/fork-tab-bar.patch          # what the fork adds on top of $OLD_TAG"
echo "  cat $WORKDIR/upstream-tab-bar.patch      # what upstream changed $OLD_TAG -> $NEW_TAG"
echo
echo "After reapplying customizations, sanity-check with:"
echo "  diff -ruN $WORKDIR/$NEW_TAG/default-plugins/tab-bar/src tab-bar/src"
echo "  diff -ruN $WORKDIR/$NEW_TAG/default-plugins/compact-bar/src compact-bar/src"
echo "The diff must be exactly the fork-customizations (show_tab_indices + permissions handshake)."
