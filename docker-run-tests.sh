#!/usr/bin/env bash

set -eu

docker run -it \
  --rm \
  --mount src="$(pwd)",target=/dictionarydecoder,type=bind \
   swift:5.8-jammy \
  /usr/bin/swift test --package-path /dictionarydecoder
