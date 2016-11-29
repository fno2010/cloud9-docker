#!/bin/bash

# mkdir -p plugins
# mkdir -p workspace

docker run -d -p 9000:80 -p 3000:3000 -p 9001-9100:9001-9100 \
    --privileged=true --cap-add NET_ADMIN --cap-add SYS_MODULE \
    --name devopen \
    -v /lib/modules:/lib/modules \
    -v $(pwd)/conf/devopen-config.js:/cloud9/configs/devopen-config.js \
    -v $(pwd)/conf/devopen.js:/cloud9/configs/devopen.js \
    -v $(pwd)/conf/client-devopen.js:/cloud9/configs/client-devopen.js \
    -v $(pwd)/conf/client-workspace-devopen.js:/cloud9/configs/client-workspace-devopen.js \
    -v $(pwd)/conf/devopen-settings.js:/cloud9/settings/devopen.js \
    $(for i in $(ls plugins); do echo "-v $(pwd)/plugins/$i:/cloud9/plugins/$i"; done) \
    -v $(pwd)/workspace/:/workspace/ fno2010/devopen
