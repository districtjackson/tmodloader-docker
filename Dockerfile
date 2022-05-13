FROM mono:slim

# Update and install needed utils
RUN apt update && \
    apt upgrade -y && \
    apt install -y curl nuget && \
    apt clean

# Download and install tModLoader
ENV TMODLOADER_VERSION="0.11.8.9"

RUN mkdir /tmp/terraria && \
    cd /tmp/terraria && \
    curl -sL https://github.com/tModLoader/tModLoader/releases/download/v${TMODLOADER_VERSION}/tModLoader.Linux.v${TMODLOADER_VERSION}.tar.gz --output tmodloader.tar.gz && \
    mkdir tModLoader && \
    tar xf tmodloader.tar.gz --directory tModLoader && \
    mv tModLoader /server && \
    rm -rf /tmp/terraria
    
COPY serverconfig-default.txt /server/serverconfig-default.txt
COPY run.sh /server/run.sh

# Commit Hash Metadata
ARG VCS_REF
LABEL org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/mrivnak/tmodloader-docker"

# Allow for external data
VOLUME ["/config"]

# Run the server
WORKDIR /server
ENTRYPOINT ["./run.sh"]
