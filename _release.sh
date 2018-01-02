#!/bin/bash

echo "Uploading docs"

ncftpput -R -v -u $ftp_username -p $ftp_password search-guard.com  /latest ./_site/*