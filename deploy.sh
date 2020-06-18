#!/bin/bash

rm -rf ./_site

bundle install
bundle exec jekyll build --config _config.yml,_versions.yml

echo "Checking access to webserver"
ssh -T cirunner@185.233.188.50 || exit 1

echo "Copying files to webserver"
rsync -r ./_site/* "cirunner@185.233.188.50:/usr/share/nginx/html/_site/docs/$VERSION" || exit 1

echo "Relinking the current latest version as the latest link"
ssh cirunner@185.233.188.50 'cd /usr/share/nginx/html/_site/docs/; latest_version=`ls -l ./|grep -v latest|grep -v total|cut -f9 -d" "|sort|uniq|tail -n 1`; ln -s $latest_version latest' || exit 1

export GIT_COMMIT_DESC=$(git log --format=oneline -n 1 $CIRCLE_SHA1)
echo "Last commit message: $GIT_COMMIT_DESC"
if [[ $GIT_COMMIT_DESC == *"noindex"* ]]; then
  echo "Skipping Search Index"
else
  echo "Rebuilding Search Index"
  bundle exec jekyll algolia push --config _config.yml,_versions.yml
fi