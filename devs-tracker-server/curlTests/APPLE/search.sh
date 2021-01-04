#!/bin/bash

# By bundleId
http://itunes.apple.com/lookup?bundleId=com.crionuke.plann&country=ru
http://itunes.apple.com/lookup?bundleId=com.crionuke.gunlayer&country=ru
# By apple id
http://itunes.apple.com/lookup?id=1505100245&country=ru
http://itunes.apple.com/lookup?id=1505100245&country=ru
http://itunes.apple.com/lookup?id=1202696702
#By artist id
http://itunes.apple.com/lookup?id=1202696701&country=ru
http://itunes.apple.com/lookup?id=1202696701&entity=software
http://itunes.apple.com/lookup?id=714804730&entity=software
http://itunes.apple.com/lookup?id=460175496&entity=software

curl -X GET "https://itunes.apple.com/search?term=voodoo&country=ru&entity=software&limit=5"
curl -X GET "https://itunes.apple.com/search?term=kirill+byvshev&country=us&media=software&entity=software&attribute=softwareDeveloper&limit=5"

https://itunes.apple.com/search?term=byv&country=us&entity=software
