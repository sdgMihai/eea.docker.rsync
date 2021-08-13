#!/bin/sh
docker-compose up &
sleep 10

docker exec -it server sh -c 'mkdir /data'
docker exec -it server sh -c 'cd /data; echo mu > test'

expect -c '
    set timeout -1
    spawn sh ./docker.sh
    match_max 100000
    expect -exact "Are you sure you want to continue connecting (yes/no/\[fingerprint\])? "
    send -- "yes\r"
    expect eof
'
echo 'testing...'
if docker exec -it server sh -c  "ls -lh /data/" | grep -q total
then 
   echo "OK";
else
   echo "NOT OK";
fi

sleep 10

docker-compose down