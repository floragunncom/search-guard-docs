#!/bin/bash

# sanity checks
echo "Merge marker sanity check"
(grep -ri "<<<<<<" * || grep -ri ">>>>>>" *) && (echo "found some merge conflicts, will abort"; exit -1)

rm -rf ./_site

bundle install
bundle exec jekyll build --config _config.yml,_versions.yml

ncftpput -R -v -u $ftp_username -p $ftp_password 109.73.229.93  /7.x ./_site/*

export GIT_COMMIT_DESC=$(git log --format=oneline -n 1 $CIRCLE_SHA1)

echo "Last commit message: $GIT_COMMIT_DESC"

if [[ $GIT_COMMIT_DESC == *"noindex"* ]]; then
  echo "Skipping Search Index"
else
  echo "Rebuilding Search Index"
  jekyll algolia push --config _config.yml,_versions.yml
fi