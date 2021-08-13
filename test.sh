#!/bin/sh
docker-compose up &
sleep 8

RESULT="NOT OK"

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
if docker exec -it client sh -c  "ls -lh /data/test"
then 
   RESULT=OK;
fi

sleep 10

docker-compose down
sleep 3
echo "=================================================================================="
echo ${RESULT}
echo "=================================================================================="