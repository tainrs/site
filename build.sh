#!/bin/bash

#
#  _______ _______ _____ __   _  ______ _______
#     |    |_____|   |   | \  | |_____/ |______
#     |    |     | __|__ |  \_| |    \_ ______|
#

# The  build.sh  script builds the Docker image and outputs the command to run the image. The script also creates an alias for the command.
# The  Dockerfile  file is used to build the Docker image.

# `jq` is required to parse the VERSION.json file. The output of jq is used to set the build arguments.
#
# Example command:
# jq -r 'to_entries[] | [(.key | ascii_upcase),.value] | join("=")' < VERSION.json
#
# Example output:
# DESCRIPTION=Alpine 3.20
# UPSTREAM_DIGEST_AMD64=sha256:dabf91b69c191a1a0a1628fd6bdd029c0c4018041c7f052870bb13c5a222ae76
# UPSTREAM_DIGEST_ARM64=sha256:647a509e17306d117943c7f91de542d7fb048133f59c72dff7893cffd1836e11
# UPSTREAM_IMAGE=alpine
# UPSTREAM_TAG=3.20
# VERSION=3.2.0.0
# VERSION_S6=3.2.0.0

# Function to determine if the script is sourced or executed
is_sourced() {
    # Check if the current script is sourced
    # by comparing $BASH_SOURCE to $0
    [[ "${BASH_SOURCE[0]}" != "${0}" ]]
}

# Set the organization name for the Docker image.
org=tainrs

# Get the name of the current Git repository and use it as the image name.
image=$(basename "$(git rev-parse --show-toplevel)")
platform=amd64

# Build the Docker image with the following options:
# --progress=plain: Show the plain build output.
# --platform: Set the target platform for the build (e.g., linux/amd64).
# -f: Specify the Dockerfile to use for the build.
# -t: Tag the image with the format "org/repo-platform".
# $(for ... ; done; echo $out; out=""): Parse the VERSION.json file with `jq`, convert the keys to uppercase,
# and use the key-value pairs as build arguments.
docker build --platform "${platform}" -f "./Dockerfile" -t "${org}/${image}" $(for i in $(jq -r 'to_entries[] | [(.key | ascii_upcase),.value] | join("=")' < VERSION.json); do out+="--build-arg $i " ; done; echo $out; out="") .

# Output the Docker run command: 'docker run --rm -it -v ${PWD}:/docs tainrs/site new .'
echo ""
echo " ---------------------------------------------------"
echo "   _______ _______ _____ __   _  ______ _______"
echo "      |    |_____|   |   | \  | |_____/ |______"
echo "      |    |     | __|__ |  \_| |    \_ ______|"
echo ""
echo " ---------------------------------------------------"
echo "To run the 'mkdocs' command, use the following command:"
echo
echo "  docker run --rm -it --name site -p 8000:8000 -v \"\${PWD}:/docs\" -v \"\${HOME}/.ssh:/home/mkdocs/.ssh:ro\" -u \$(id -u):\$(id -g) ${org}/${image}"
echo
echo "For example:"
echo
echo "  docker run --rm -it --name site -p 8000:8000  -v \"${PWD}:/docs\" -v \"${HOME}/.ssh:/home/mkdocs/.ssh:ro\" -u $(id -u):$(id -g) ${org}/${image}"
echo
if is_sourced; then
    alias mkdocs='docker run --rm -it --name site -p 8000:8000 -v "${PWD}:/docs" -v "${HOME}/.ssh:/home/mkdocs/.ssh:ro" -u $(id -u):$(id -g) tainrs/site'
    alias mkdocs-serve='docker run --rm -it --name site -p 8000:8000 -v "${PWD}:/docs" -v "${HOME}/.ssh:/home/mkdocs/.ssh:ro" -u $(id -u):$(id -g) tainrs/site serve --dev-addr=0.0.0.0:8000'
    alias mkdocs-deploy='docker run --rm -it --name site -p 8000:8000 -v "${PWD}:/docs" -v "${HOME}/.ssh:/home/mkdocs/.ssh:ro" -u $(id -u):$(id -g) tainrs/site gh-deploy --clean --no-history --force'
    echo "Created 'mkdocs', 'mkdocs-serve' and 'mkdocs-deploy' aliases for use in the current environment."
else
    echo "Reminder: If you want to 'serve' the site, use the 'serve --dev-addr=0.0.0.0:8000' command."
    echo "          Otherwise 127.0.0.1 is used which does not work in a container."
    echo
    echo "Tip:      For ease of use, you call this script by sourcing it in your current shell session."
    echo "          'mkdocs', 'mkdocs-serve' and 'mkdocs-deploy' aliases will be created for use in the current environment."
fi
echo
echo " ---------------------------------------------------"
