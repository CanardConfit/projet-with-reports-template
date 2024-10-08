#!/bin/bash

OPTIONS="--toc --filter=pandoc-plot --filter=pandoc-numbering --filter=pandoc-crossref"
PDFOPTIONS="--highlight-style kate --pdf-engine xelatex --number-sections"

FORCE_REBUILD="${FORCE_REBUILD:-false}"

echo "Building (Force=$FORCE_REBUILD)..."

for dir in Labo*/; do
    if [ "$FORCE_REBUILD" = "true" ] || git diff --name-only "$CI_COMMIT_BEFORE_SHA" "$CI_COMMIT_SHA" | grep -q "^${dir}rapport.md$"; then
        echo "Building report in ${dir}"
        cd "${dir}" || exit

        pandoc -s $OPTIONS $PDFOPTIONS --to=latex -o rapport.tex rapport.md || true

        pandoc -s $OPTIONS $PDFOPTIONS -o rapport.pdf rapport.md || true

        base_name=$(echo "${dir}" | sed 's/\/$//')
        mv rapport.tex "../${base_name}.tex" || true
        mv rapport.pdf "../${base_name}.pdf" || true

        cd - || exit
    fi
done