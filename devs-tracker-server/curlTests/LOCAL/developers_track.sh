#!/bin/bash

curl -v -X POST -H "Content-Type: application/json" -H "Authorization: Bearer AnonymousUser0001" \
    http://localhost:8080/devstracker/v1/developers/1183043255/track
#    http://localhost:8080/devstracker/v1/developers/1471988506/track