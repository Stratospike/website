#!/bin/bash

cat << EOT
Content-type: text/html

<html>
<head><title>Site Update</title></head>
<body>
<pre>
EOT

cd /var/www
/usr/bin/git pull < /dev/null 2>> /tmp/git-pull.log

echo "</pre></body></html>"
