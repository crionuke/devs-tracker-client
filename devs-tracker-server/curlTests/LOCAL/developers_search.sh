#!/bin/bash

curl -v -H "Content-Type: application/json" \
    -d "{ \"countries\": [ \"us\", \"ru\" ], \"term\": \"kirill\" }" \
    http://localhost:8080/devstracker/v1/developers/search
