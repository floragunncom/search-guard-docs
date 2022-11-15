#!/bin/bash

echo "## removing old _site directory"
rm -rf ./_site

echo "## building docs"
bundle install
bundle exec jekyll build --config _config.yml,_versions.yml

site_dir=$(grep "baseurl:" ./_versions.yml  | awk '{print $2}')
sftp_directory=$(sed 's/^\///' <<< $site_dir )
sftp_root_directory='html'

#set default server
if [  ! ${sftp_server+x} ];  then
  sftp_server=185.233.188.50
fi

# Sanity check, do not upload feature branches etc.

if [ -z "$CI_JOB_ID" ] ; then
    echo "CI_JOB_ID not set, seems we run locally, fetch branch name from git"
    git_branch=$(git rev-parse --abbrev-ref HEAD)
else
    echo "CI_JOB_ID set, seems we run om CI, fetch branch name from environment"
    git_branch=$CI_COMMIT_BRANCH
fi

echo "Building branch $git_branch"

if [[ ! $git_branch =~ ^7.x-[0-9]{2}$ ]]; then
    echo "Branch $git_branch does not seem to be a release branch, exiting gracefully"
    exit 0
fi

if [ "$ftp_file_upload" = true ] ; then
  echo "## Uploading to FTP directory: $site_dir"
  ncftpput -R -v -u $ftp_username -p $ftp_password 35.214.156.137  "$site_dir" ./_site/*
  export GIT_COMMIT_DESC=$(git log --format=oneline -n 1 $CIRCLE_SHA1)
  echo "Last commit message: $GIT_COMMIT_DESC"
else 
  echo "FTP upload is disabled"    
fi

if [ "$sftp_file_upload" = true ] ; then

  echo "## Uploading to SFTP Server $sftp_server directory: $ftp_dir"
  echo "Set ssh configuration for SFTP"
  which ssh-agent || ( apt-get update -y && apt-get install openssh-client -y )
  eval $(ssh-agent -s)
  echo "$sftp_user_private_key_base64" | base64 -d | tr -d '\r' | ssh-add -
  mkdir -p ~/.ssh
  echo -e "Host *\n\tStrictHostKeyChecking no\n\n" > ~/.ssh/config

  echo "Uploading fles to SFTP server"

sftp  -b - $sftp_user_name@$sftp_server <<EOF
    -mkdir $sftp_root_directory/$sftp_directory
    put -r /builds/search-guard/search-guard-docs/_site/* $sftp_root_directory/$sftp_directory
EOF

else 
 echo "SFTP upload is disabled"    
fi

if [[ $GIT_COMMIT_DESC == *"noindex"* ]]; then
  echo "## Skipping Search Index"
else
  echo "## Rebuilding Search Index"
  bundle exec jekyll algolia push --config _config.yml,_versions.yml
fi