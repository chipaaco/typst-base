#!/usr/bin/env bash

set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <organizer-folder>"
  exit 1
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
organizer="$1"
organizer_path="$script_dir/$organizer"

if [ ! -d "$organizer_path" ]; then
  mkdir -p "$organizer_path"
fi

random_name="project_${RANDOM}${RANDOM}"
while [ -e "$organizer_path/$random_name" ]; do
  random_name="project_${RANDOM}${RANDOM}"
done

mkdir -p "$organizer_path/$random_name"
cp -a "$script_dir/base_template/." "$organizer_path/$random_name/"
