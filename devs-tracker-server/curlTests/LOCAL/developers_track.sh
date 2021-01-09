#!/bin/bash

curl -v -X POST -H "Content-Type: application/json" \
    -d "{ \"anonymousId\": \"AnonymousUser0001\" }" \
    http://localhost:8080/devstracker/v1/developers/1471988506/track