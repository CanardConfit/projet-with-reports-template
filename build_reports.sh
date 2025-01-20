#!/bin/sh

GIT_REPO_PATH="${GIT_REPO_PATH:-/build}"
FORCE_REBUILD="${FORCE_REBUILD:-false}"

OPTIONS="--filter=pandoc-plot --filter=pandoc-numbering --filter=pandoc-crossref -H /data/disable_float_image.tex"
PDFOPTIONS="--highlight-style kate --pdf-engine xelatex --number-sections"

if [ -z "$NO_TOC" ] || [ "$NO_TOC" = "false" ]; then
    OPTIONS="$OPTIONS --toc"
fi

cd "$GIT_REPO_PATH" || exit 1

if [ -z "$CI_COMMIT_BEFORE_SHA" ] || [ "$CI_COMMIT_BEFORE_SHA" = "0000000000000000000000000000000000000000" ]; then
    echo "CI_COMMIT_BEFORE_SHA invalid, forcing rebuild."
    FORCE_REBUILD="true"
fi

echo "Current directory: $(pwd)"

echo "GIT_REPO_PATH: $GIT_REPO_PATH"
echo "FORCE_REBUILD: $FORCE_REBUILD"

echo "Building..."

for dir in Labo*/; do
    if [ "$FORCE_REBUILD" = "true" ] || git diff --name-only "$CI_COMMIT_BEFORE_SHA" "$CI_COMMIT_SHA" -- "${dir}rapport.md" | grep -q "."; then
        echo "Building report in ${dir}"
        cd "${dir}" || exit 1

        pandoc -s $OPTIONS $PDFOPTIONS --to=latex -o rapport.tex rapport.md || true

        pandoc -s $OPTIONS $PDFOPTIONS -o rapport.pdf rapport.md || true

        base_name=$(echo "${dir}" | sed 's/\/$//')
        mv rapport.tex "../${base_name}.tex" || true
        mv rapport.pdf "../${base_name}.pdf" || true

        cd "$GIT_REPO_PATH" || exit 1
    fi
done
