#!/usr/bin/env bash
set -e
docker build -t sg-docs-local .

#echo "First pass running "
#docker run --rm -it -v "$(pwd)":/app \
#  --entrypoint sh \
#  sg-docs-local \
#  -c "bundle exec jekyll build --config _config.yml,_versions.yml --incremental" > /dev/null
#
#echo "Second pass running "
#docker run --rm -it -v "$(pwd)":/app \
#  --entrypoint sh \
#  sg-docs-local \
#  -c "bundle exec jekyll build --config _config.yml,_versions.yml --incremental" > /dev/null

#docker run --rm -it -p 4000:4000 -v "$(pwd)":/app -v bundle_cache:/usr/local/bundle sg-docs-local
docker run --rm -it -p 4000:4000 -v "$(pwd)":/app sg-docs-local
