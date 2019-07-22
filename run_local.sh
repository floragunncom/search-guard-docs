#!/bin/bash
bundle install
bundle exec jekyll serve --watch --config _config.yml,_versions.yml
