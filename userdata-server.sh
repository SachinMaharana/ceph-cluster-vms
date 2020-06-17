#!/bin/bash
apt-get update -y
apt install nginx -y 
systemctl restart nginx && systemctl reload nginx
mv /var/www/html/index.html  /var/www/html/index.html.backup

cat <<EOF > /var/www/html/index.html
<h1>Welcome!</h1>
We hope you <i>really</i> enjoy your stay here.
EOF