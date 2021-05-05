#!/bin/bash

./kill.sh
rm -rf dev-tracker-db
sleep 2
./up.sh
docker logs dev-tracker-db