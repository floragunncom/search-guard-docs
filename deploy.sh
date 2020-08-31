#!/bin/bash

echo "## removing old _site directory"
rm -rf ./_site

echo "## building docs"
bundle install
bundle exec jekyll build --config _config.yml,_versions.yml

ftp_dir=$(grep "baseurl:" ./_versions.yml  | awk '{print $2}')

# Sanity check, do not upload feature branches etc.
git_branch=$(git rev-parse --abbrev-ref HEAD)

if [[ ! $git_branch =~ ^7.x-[1-9]{2}$ ]]; then
    echo "Branch $git_branch does not seem to be a release branch, exiting gracefully"
    exit 0
fi

echo "## Uploading to FTP directory: $ftp_dir"
ncftpput -R -v -u $ftp_username -p $ftp_password 35.214.156.137  "$ftp_dir" ./_site/*

export GIT_COMMIT_DESC=$(git log --format=oneline -n 1 $CIRCLE_SHA1)
echo "Last commit message: $GIT_COMMIT_DESC"

if [[ $GIT_COMMIT_DESC == *"noindex"* ]]; then
  echo "## Skipping Search Index"
else
  echo "## Rebuilding Search Index"
  bundle exec jekyll algolia push --config _config.yml,_versions.yml
fi