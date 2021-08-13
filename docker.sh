#!/bin/sh

docker exec -it client sh -c "rsync -e 'ssh -p 22' -avz root@server:/data/ /data/;"