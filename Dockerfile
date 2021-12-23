FROM mono:slim

# Update and install needed utils
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y curl nuget vim zip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# fix for favorites.json error
RUN favorites_path="/root/My Games/Terraria" && mkdir -p "$favorites_path" && echo "{}" > "$favorites_path/favorites.json"

# Download and install Vanilla Server
ENV GAME_VERSION=1353
ENV TMODLOADER_VERSION="0.11.8.5"

RUN mkdir /tmp/terraria && \
    cd /tmp/terraria && \
    curl -sL https://www.terraria.org/api/download/pc-dedicated-server/terraria-server-${GAME_VERSION}.zip --output terraria-server.zip && \
    curl -sL https://github.com/tModLoader/tModLoader/releases/download/v${TMODLOADER_VERSION}/tModLoader.Linux.v${TMODLOADER_VERSION}.tar.gz --output tmodloader.tar.gz && \
    unzip -q terraria-server.zip && \
    tar xf tmodloader.tar.gz && \
    mv */Linux /vanilla && \
    mv */Windows/serverconfig.txt /vanilla/serverconfig-default.txt && \
    rm -R /tmp/* && \
    chmod +x /vanilla/TerrariaServer* && \
    if [ ! -f /vanilla/TerrariaServer ]; then echo "Missing /vanilla/TerrariaServer"; exit 1; fi
    

COPY run.sh /vanilla/run.sh

# Commit Hash Metadata
ARG VCS_REF
LABEL org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/mrivnak/tmodloader-docker"

# Allow for external data
VOLUME ["/config"]

# Run the server
WORKDIR /vanilla
ENTRYPOINT ["./run.sh"]
