#!/bin/bash
# Starting Node 

cd /usr/src/app
nohup node dist/server.js &
#Starting Nginx
/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf