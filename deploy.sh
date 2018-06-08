#!/bin/bash

set -e

cd ${TRAVIS_BUILD_DIR}/_book

for file in $(find -type f); do
  curl --ftp-create-dirs -s -S \
    -T "$file" \
    -u "${FTP_USER}:${FTP_PASSWORD}" \
    "ftp://${FTP_HOST}/public_html/guide/test/$1/${file}"
done
