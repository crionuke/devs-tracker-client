#!/bin/bash

# Voodoo
#curl -X GET "http://itunes.apple.com/lookup?id=714804730&entity=software&limit=200&country=us" | jq
# Konstantin Boronenkov
curl -X GET "http://itunes.apple.com/lookup?id=660671521&entity=software&limit=200&country=ru" | jq
# Kirill Byvshev
#curl -X GET "http://itunes.apple.com/lookup?id=1202696701&entity=software&limit=200&country=ru" | jq
