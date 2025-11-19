#!/bin/sh

crond -c /etc/crontabs

if [ ! -f /app/bin/geoip.dat ]; then
  /app/DockerInit.sh update_geodata "/app/bin"
fi

# Start fail2ban
[ "$XUI_ENABLE_FAIL2BAN" = "true" ] && fail2ban-client -x start

# Run x-ui
exec /app/x-ui
