#!/usr/bin/env sh

command -v jazzy >/dev/null 2>&1 || {
  echo >&2 "[GENDOC] Jazzy not found, attempting to install..."
  gem install jazzy
}

BASE_DIR="$(dirname $(greadlink -f $0))"
SPEC_PATH="$BASE_DIR/../PaylineSDK.podspec"
DOC_PATH="$BASE_DIR/../Documentation/jazzydoc"

echo '[GENDOC] Removing old docs...'
rm -rf "$DOC_PATH"

echo '[GENDOC] Generating API reference documentation using Jazzy...'
jazzy --podspec "$SPEC_PATH" -o "$DOC_PATH"
