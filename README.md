# terraria

Docker images to run a Terraria Server with tModLoader

## Usage

### With Docker CLI

#### Build

```
docker build -t terraria-tmodloader .
```

#### Run

```
docker create --rm -it \
  --name=terraria-tmodloader \
  -v <path to data>:/config \
  -e WORLD=<world_file_name> \
  -p 7777:7777 \
  terraria-tmodloader
```

### With Docker-Compose

#### Example Docker Compose file
Here is an example docker-compose file that enables to the use of the vanilla server
```
version: '3'

services:
  terraria:
    build: .
    ports:
      - '7777:7777'
    restart: unless-stopped
    environment:
      - world=<world_file_name>
    volumes:
      - $HOME/terraria/config:/config
    tty: true
    stdin_open: true
```

#### Environment options

| ENV Variable | Description | Example |
| --- | --- | --- |
| WORLD | World filename | World.wld |
| PASSWORD | Server password | password123 |
| MOTD | Message of the Day | "Welcome to tModLoader" |
| PORT | Server port | 7777 |
| BACKUPS | Number of backups to keep | 5 |
| TMODLOADER_VERSION | tModLoader version string | "0.11.8.5" |

#### Running

```shell
docker compose up -d
```

### Generating a new world
To run with out user intervention Terraria Server needs to be configure to use an already generated world. This means you can use one that you have already generated or you can generate one via docker by running this command:
```
docker run --rm -it -p 7777:7777 \
    -v <path to data>:/config \
    --name=terraria-tmodloader \
    terraria-tmodloader
```

If you want to reattach to any running containers:
`sudo docker attach terraria`
Now you can execute any commands to the terraria server. Ctrl-p Ctrl-q will detatch you from the process.

#### License

The MIT License (MIT)

Copyright (c) 2021 Michael Rivnak
