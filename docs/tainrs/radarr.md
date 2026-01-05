---
hide:
  - toc
---

--8<-- "includes/header-links.md"

## Starting the container

=== "cli"

    ```shell linenums="1"
    docker run --rm \
        --name radarr \
        -p 7878:7878 \
        -e PUID=1000 \ #(1)!
        -e PGID=1000 \ #(2)!
        -e UMASK=002 \ #(3)!
        -e TZ="Etc/UTC" \
        -v ~/config:/config \ #(4)!
        -v ~/data:/data \
        docker.io/tainrs/radarr
    ```

    --8<-- "includes/annotations.md"

=== "compose"

    ```yaml linenums="1"
    services:
      radarr:
        container_name: radarr
        image: docker.io/tainrs/radarr
        ports:
          - "7878:7878"
        environment:
          - PUID=1000 #(1)!
          - PGID=1000 #(2)!
          - UMASK=002 #(3)!
          - TZ=Etc/UTC
        volumes:
          - ~/config:/config
          - ~/data:/data
    ```

    --8<-- "includes/annotations.md"

This is the Radarr container.

--8<-- "includes/tags.md"
