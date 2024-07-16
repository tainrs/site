# Define arguments for the upstream image and its digest for AMD64 architecture
ARG UPSTREAM_IMAGE
ARG UPSTREAM_DIGEST

# Use the upstream image as the base image for this Dockerfile
FROM ${UPSTREAM_IMAGE}@${UPSTREAM_DIGEST}

# Install git and openssh-client
RUN set -e ;\
    apk add --no-cache \
        git \
        openssh-client ;\
    rm -rf /var/cache/apk/*

# Set the SSH_AUTH_SOCK environment variable
ENV SSH_AUTH_SOCK=/ssh-agent

# Create heredoc entrypoint script
RUN set -e ;\
    echo '#!/bin/sh' > /entrypoint.sh ;\
    echo 'exec 3>&1 ; exec 1>/dev/null' >> /entrypoint.sh ;\
    echo 'eval $(ssh-agent -s)' >> /entrypoint.sh ;\
    echo 'ssh-add -l' >> /entrypoint.sh ;\
    echo 'exec 1>&3 ; exec 3>&-' >> /entrypoint.sh ;\
    echo 'exec /sbin/tini -- mkdocs "$@"' >> /entrypoint.sh ;\
    chmod +x /entrypoint.sh

# Install additional mkdocs plugins
# RUN pip install mkdocs-macros-plugin
# RUN pip install mkdocs-glightbox

# Create mkdocs user and group
RUN set -e ;\
    addgroup -g 1000 -S mkdocs ;\
    adduser -u 1000 -S -G mkdocs mkdocs

USER mkdocs

ENTRYPOINT ["/entrypoint.sh"]

CMD ["--help"]
