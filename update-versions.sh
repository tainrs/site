#!/bin/bash

# This script is designed to update the version number in a local JSON file (VERSION.json)
# with the latest version number for mkdocs-material.
# It uses the 'curl' command to fetch the latest version from GitHub, 'jq' to parse and manipulate JSON data,
# and 'tee' to write the output back to VERSION.json.

branch="master"
url="https://api.github.com/repos/squidfunk/mkdocs-material/releases/latest"
json=$(cat VERSION.json)

# Fetch the latest version from GitHub
latest_version=$(curl -SsL "${url}" | jq -r '.tag_name')

# Extract the current version from VERSION.json.
current_version=$(jq -r '.version' <<< "${json}")

# Extract major versions (only if the output is not empty or null)
latest_major_version=$(echo $latest_version | cut -d '.' -f 1)
current_major_version=$(echo $current_version | cut -d '.' -f 1)

echo "Latest version: ${latest_major_version}"
echo "Current version: ${current_major_version}"

# Check if the major version has changed and major version is not null
if [[ "${latest_major_version}" != "${current_major_version}" && ! -z "${latest_major_version}" ]]; then
    echo "Major version has changed. Updating the version number."
else
    echo "Major version has not changed. Skipping the update."
    exit 0
fi

# Update the version and branch in VERSION.json
jq --sort-keys \
    --arg version "${latest_version//v/}" \
    --arg branch "${branch}" \
    --arg tag "${latest_major_version}" \
    '.version = $version | .branch = $branch | .upstream_tag = $tag' <<< "${json}" | tee VERSION.json
