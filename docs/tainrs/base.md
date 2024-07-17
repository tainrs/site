---
hide:
  - toc
---

--8<-- "includes/header-links.md"

## Starting the container

=== "cli"

    ```shell linenums="1"
    docker run --rm \
        --name base \
        -e PUID=1000 \ #(1)!
        -e PGID=1000 \ #(2)!
        -e UMASK=002 \ #(3)!
        -e TZ="Etc/UTC" \
        -v ~/config:/config \ #(4)!
        docker.io/tainrs/base:alpine
    ```

    --8<-- "includes/annotations.md"

=== "compose"

    ```yaml linenums="1"
    services:
      base:
        container_name: base
        image: docker.io/tainrs/base:alpine
        environment:
          - PUID=1000 #(1)!
          - PGID=1000 #(2)!
          - UMASK=002 #(3)!
          - TZ=Etc/UTC
        volumes:
          - ~/config:/config
    ```

    --8<-- "includes/annotations.md"

This image is the base image for all other application images.

--8<-- "includes/tags.md"
