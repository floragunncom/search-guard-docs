#!/bin/bash

rm -rf ./_site

bundle install
bundle exec jekyll build --config _config.yml,_versions.yml