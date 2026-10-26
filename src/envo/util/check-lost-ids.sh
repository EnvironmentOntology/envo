#!/usr/bin/env bash
# Fails if an ENVO term that has a label on the base revision has no label on
# the head revision. Terms are never deleted, only obsoleted (an obsolete term
# keeps its IRI and its "obsolete ..." label, so obsoletion passes).
#
# Only ENVO's own sources are compared: the edit file without its imports,
# plus the modules and templates merged into envo-base.owl. Terms that appear
# only in an import module (e.g. via FOODON) do not count.
#
# usage: check-lost-ids.sh BASE_DIR HEAD_DIR EDIT_FILE [EXTRA_FILE ...]
#   BASE_DIR, HEAD_DIR: the src/envo directory of each revision
#   files are relative to those directories; extra files missing on one side
#   are skipped, so adding or retiring a module does not break the check

set -euo pipefail

if [ $# -lt 3 ]; then
	echo "usage: $0 BASE_DIR HEAD_DIR EDIT_FILE [EXTRA_FILE ...]" >&2
	exit 2
fi

BASE_DIR=$1
HEAD_DIR=$2
EDIT_FILE=$3
shift 3

QUERY="$(cd "$(dirname "$0")/.." && pwd)/sparql/labelled-envo-terms.sparql"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

labelled_terms() {
	local dir=$1 out=$2 merge_args=() f
	shift 2
	for f in "$@"; do
		if [ -f "$dir/$f" ]; then
			merge_args+=(-i "$dir/$f")
		fi
	done
	robot --catalog "$dir/catalog-v001.xml" \
		remove --input "$dir/$EDIT_FILE" --select imports --trim false \
		merge "${merge_args[@]}" \
		query --format tsv --query "$QUERY" "$out"
	# drop the header row and keep IRI<TAB>label, sorted by IRI
	tail -n +2 "$out" | LC_ALL=C sort -u -t "$(printf '\t')" -k1,1 > "$out.sorted"
}

labelled_terms "$BASE_DIR" "$TMP/base.tsv" "$@"
labelled_terms "$HEAD_DIR" "$TMP/head.tsv" "$@"

cut -f1 "$TMP/head.tsv.sorted" > "$TMP/head.ids"
LC_ALL=C join -t "$(printf '\t')" -v 1 "$TMP/base.tsv.sorted" "$TMP/head.ids" > "$TMP/lost.tsv"

BASE_COUNT=$(wc -l < "$TMP/base.tsv.sorted" | tr -d ' ')
HEAD_COUNT=$(wc -l < "$TMP/head.tsv.sorted" | tr -d ' ')
LOST_COUNT=$(wc -l < "$TMP/lost.tsv" | tr -d ' ')

echo "Labelled ENVO terms: $BASE_COUNT on base, $HEAD_COUNT on head."

if [ "$LOST_COUNT" -gt 0 ]; then
	echo "ERROR: $LOST_COUNT ENVO term(s) present on the base revision are gone or lost their label:" >&2
	cat "$TMP/lost.tsv" >&2
	echo "ENVO IDs must never be deleted. Obsolete the term instead (owl:deprecated true, 'obsolete' label, replaced_by or consider)." >&2
	exit 1
fi

echo "OK: no ENVO term was lost."
