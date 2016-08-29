#!/bin/bash

mkdir -p plugins
mkdir -p workspace

sudo docker run -d -p 9000:80 \
    -v $(pwd)/conf/test-config.js:/cloud9/configs/test-config.js \
    -v $(pwd)/conf/client-workspace-test.js:/cloud9/configs/client-workspace-test.js \
    $(for i in $(ls plugins); do echo "-v \$(pwd)/plugins/$i:/cloud9/plugins/$i"; done) \
    -v $(pwd)/workspace/:/workspace/ $USER/cloud9-docker:latest
