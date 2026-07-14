#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

set -e

rm -rf "$SCRIPT_DIR/.jekyll-cache" "$SCRIPT_DIR/_site"
rm -f "$SCRIPT_DIR/.jekyll-metadata"

docker build -t sg-docs-local .

#echo "First pass running "
#docker run --rm -it -v "$SCRIPT_DIR":/app \
#  --entrypoint sh \
#  sg-docs-local \
#  -c "bundle exec jekyll build --config _config.yml,_versions.yml --incremental" > /dev/null
#
#echo "Second pass running "
#docker run --rm -it -v "$SCRIPT_DIR":/app \
#  --entrypoint sh \
#  sg-docs-local \
#  -c "bundle exec jekyll build --config _config.yml,_versions.yml --incremental" > /dev/null

#docker run --rm -it -p 4000:4000 -v "$SCRIPT_DIR":/app -v bundle_cache:/usr/local/bundle sg-docs-local
docker run --rm -it -p 4000:4000 -v "$SCRIPT_DIR":/app sg-docs-local
