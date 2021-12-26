#!/bin/bash
set -euo pipefail

CMD="./tModLoaderServer -x64 -config /config/serverconfig.txt"

# Create default config files if they don't exist
if [ ! -f "/config/serverconfig.txt" ]; then
    cp ./serverconfig-default.txt /config/serverconfig.txt
fi

if [ ! -f "/config/banlist.txt" ]; then
    touch /config/banlist.txt
fi

# Configure new paths
mkdir -p /config/mods
# commented out for now since these should already be set
# sed -i -e "/worldpath=/s/=.*/=\/config\//" -e '/worldpath=/s/#//' /config/serverconfig.txt
# sed -i -e "/modpath=/s/=.*/=\/config\/mods/" -e '/modpath=/s/#//' /config/serverconfig.txt


# Pass in world if set
if [ "${WORLD:-null}" != null ]; then
    if [ ! -f "/config/$WORLD" ]; then
        echo "World file does not exist! Quitting..."
        exit 1
    else
        sed -i -e "/world=/s/=.*/=\/config\/${WORLD}/" -e '/world=/s/#//' /config/serverconfig.txt
    fi
fi

# Pass in server password if set
if [ "${PASSWORD:-null}" != null ]; then
    sed -i -e "/password=/s/=.*/=${PASSWORD}/" -e '/password=/s/#//' /config/serverconfig.txt
fi

# Pass in server motd if set
if [ "${MOTD:-null}" != null ]; then
    sed -i -e "/motd=/s/=.*/=${PASSWORD}/" -e '/motd=/s/#//' /config/serverconfig.txt
fi

# Set server port
if [ "${PORT:-null}" != null ]; then
    sed -i -e "/port=/s/=.*/=${PORT}/" -e '/port=/s/#//' /config/serverconfig.txt
fi

# Server backups
if [ "${BACKUPS:-null}" != null ]; then
    sed -i -e "/worldrollbackstokeep=/s/=.*/=${BACKUPS}/" -e '/worldrollbackstokeep=/s/#//' /config/serverconfig.txt
fi

echo "Starting container, CMD: $CMD $@"
exec $CMD $@
