#!/bin/bash
# This script auto-updates a VERSION string definition.
# It outputs informational messages to stderr, while the actual
# output (on stdout) can easily be redirected to a file.

commit_date=$(git show -s HEAD --format=%cd --date=short | sed 's/-//g')
date_and_hash="${commit_date}-$(git rev-parse --short HEAD)"

VER="${date_and_hash}"
echo >&2

echo "/* Auto-generated information. DO NOT EDIT */"
echo "#define VERSION \"${VER}\""
