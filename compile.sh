#!/usr/bin/env bash

set -euo pipefail

usage() {
  echo "Usage: $0 [-c|-w|-p] <path-to-project-or-file>"
  echo "  -c  compile to PDF"
  echo "  -w  watch changes and compile to PDF"
  echo "  -p  export to PNG"
}

mode=""
target=""

while getopts ":cwp" opt; do
  case "$opt" in
    c) mode="pdf" ;;
    w) mode="watch" ;;
    p) mode="png" ;;
    *) usage; exit 1 ;;
  esac
done

shift $((OPTIND - 1))

if [ "$#" -ne 1 ]; then
  usage
  exit 1
fi

target="$1"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "$target" = "." ]; then
  project_dir="$(pwd)"
elif [ -d "$target" ]; then
  project_dir="$(cd "$target" && pwd)"
else
  project_dir="$(cd "$(dirname "$target")" && pwd)"
fi

if [ -d "$project_dir/src" ]; then
  src_dir="$project_dir/src"
elif [ -d "$project_dir" ] && [ -f "$project_dir/main.typ" ]; then
  src_dir="$project_dir"
else
  src_dir="$project_dir/src"
fi

main_file="$src_dir/main.typ"
outputs_dir="$project_dir/outputs"
mkdir -p "$outputs_dir"

pdf_out="$outputs_dir/generated.pdf"
png_out="$outputs_dir/generated.png"

case "$mode" in
  pdf)
    typst compile "$main_file" "$pdf_out"
    ;;
  watch)
    typst watch "$main_file" "$pdf_out"
    ;;
  png)
    typst compile "$main_file" "$png_out"
    ;;
  *)
    usage
    exit 1
    ;;
esac
