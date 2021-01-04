#!/bin/bash

curl -v -H "Content-Type: application/json" \
    -d "{ \"name\": \"Sonya\" }" \
    http://localhost:8080/devstracker/v1/developers/search