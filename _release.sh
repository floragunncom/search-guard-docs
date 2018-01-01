
echo "Uploading docs"

HOST='search-guard.com'

cd ./_site

ftp -in $HOST << EOF
user $ftp_username $ftp_password
passive
cd /public_html/docs/tmp
mput *
quit
EOF