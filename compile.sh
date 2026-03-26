#!/bin/bash
# This script is intended for Ubuntu systems only

if ! command -v typst >/dev/null 2>&1; then
  echo "Error: 'typst' is not installed."
  echo "You can install it with:"
  echo "  sudo apt update && sudo apt install -y curl unzip"
  echo "  curl -LO https://typst.app/releases/typst-x86_64-unknown-linux-musl.zip"
  echo "  unzip typst-x86_64-unknown-linux-musl.zip"
  echo "  sudo mv typst /usr/local/bin/typst"
  exit 1
fi

show_help() {
  echo "Usage: $0 [options] [output-file]"
  echo "Options:"
  echo "  -h           Show this help message"
  echo "  --pdf        Compile to PDF (default)"
  echo "  --live-pdf   Compile continuously to PDF (watch mode)"
  echo "  --png        Export only as PNG image"
  echo "[output-file] Optional output file name; if omitted, uses input file and adjusts extension."
  exit 0
}

MODE="pdf"
LIVE=0
INPUT="file.typ"
OUTPUT=""

for arg in "$@"; do
  case $arg in
    -h)
      show_help
      ;;
    --pdf)
      MODE="pdf"
      ;;
    --live-pdf)
      MODE="pdf"
      LIVE=1
      ;;
    --png)
      MODE="png"
      ;;
    *)
      OUTPUT="$arg"
      ;;
  esac
done

BASENAME="${INPUT%.typ}"

if [ -z "$OUTPUT" ]; then
  if [ "$MODE" = "pdf" ]; then
    OUTPUT="$BASENAME.pdf"
  else
    OUTPUT="$BASENAME.png"
  fi
fi

if [ "$LIVE" -eq 1 ]; then
  typst watch "$INPUT" "$OUTPUT"
else
  if [ "$MODE" = "pdf" ]; then
    typst compile "$INPUT" "$OUTPUT"
  elif [ "$MODE" = "png" ]; then
    typst compile "$INPUT" --png "$OUTPUT"
  fi
fi
