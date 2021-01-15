#!/bin/bash

./kill.sh
rm -rf db
sleep 2
./up.sh
docker logs db