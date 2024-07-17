1. Set the `PUID` variable to the local user that has read & write permissions for the `config` folder. (e.g. `PUID=1000` or `PUID=$(id -u)` for the current user id)

2. Set the `GUID` variable to the local group that has read & write permissions for the `config` folder. (e.g. `GUID=1000` or `GUID=$(id -g)` for the current group id)

3. UMASK 002 is the default for most applications. This corresponds to 775 or rwxrwxr-x permissions.

4. Set the path to your config folder as needed. Here it's set to the `config` subfolder in the current directory. <br/><br/>__Hint__: you can use the current workdir as wel. e.g. `-v $(pwd)/config:/config`
