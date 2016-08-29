#!/bin/bash

mkdir -p plugins
mkdir -p workspace

sudo docker run -d -p 80:80 \
    -v test-test-config.js:/cloud9/configs/test-config.js \
    -v client-workspace-test.js:/cloud9/configs/client-workspace-test.js \
    -v plugins/:/root/.c9/dev/plugins/ \
    -v workspace/:/workspace/ $USER/cloud9-docker:latest
