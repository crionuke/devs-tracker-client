#!/bin/bash

cat /dev/null > perf1.txt
for i in {1..30}
do
curl -X GET http://itunes.apple.com/lookup?id=1202696701&entity=software >> /dev/null
done