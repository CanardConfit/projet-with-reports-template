#!/bin/bash

GIT_REPO_PATH="${GIT_REPO_PATH}"
FORCE_REBUILD="${FORCE_REBUILD:-false}"

if [ -z "$GIT_REPO_PATH" ]; then
    echo "Error: Git repository path ($GIT_REPO_PATH) must be set in the GIT_REPO_PATH environment variable."
    exit 1
fi

OPTIONS="--toc --filter=pandoc-plot --filter=pandoc-numbering --filter=pandoc-crossref"
PDFOPTIONS="--highlight-style kate --pdf-engine xelatex --number-sections"

if [ -z "$CI_COMMIT_BEFORE_SHA" ] || [ "$CI_COMMIT_BEFORE_SHA" = "0000000000000000000000000000000000000000" ]; then
    echo "CI_COMMIT_BEFORE_SHA invalid, forcing rebuild."
    FORCE_REBUILD="true"
fi

echo "GIT_REPO_PATH: $GIT_REPO_PATH"
echo "FORCE_REBUILD: $FORCE_REBUILD"

echo "Current directory: $(pwd)"

cd "$GIT_REPO_PATH" || exit 1

echo "Current directory: $(pwd)"

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