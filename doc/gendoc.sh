#!/bin/bash

DOCS="$(dirname $(readlink -f $0))"
ROOT="$(dirname ${DOCS})"

CONFIG="${DOCS}/config.ld"
OUT="${DOCS}/html"

cd "${ROOT}"
ldoc -B -c "${CONFIG}" -d "${OUT}" api.lua
