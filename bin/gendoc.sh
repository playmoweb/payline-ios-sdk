#!/usr/bin/env sh
echo '[GENDOC] Generating API reference documentation using Jazzy...'
DIR="$(dirname $(greadlink -f $0))"
jazzy --podspec "$DIR/../PaylineSDK.podspec" -o "$DIR/../Documentation/jazzydoc"
