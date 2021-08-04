#!/bin/bash

LDOC="$(dirname $(readlink -f $0))"
ROOT="$(dirname ${LDOC})"
DOCS="${ROOT}/docs"

CONFIG="${LDOC}/config.ld"

cd "${ROOT}"
rm -rf "${DOCS}/api.html" "${DOCS}/modules" "${DOCS}/scripts"
ldoc -B -c "${CONFIG}" -o "api" -d "${DOCS}" "${ROOT}"
