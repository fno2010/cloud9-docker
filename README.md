Cloud9 v3 Dockerfile
=============

This repository contains Dockerfile of Cloud9 IDE for Docker's automated build published to the public Docker Hub Registry.

# Base Docker Image
[kdelfour/supervisor-docker](https://registry.hub.docker.com/u/kdelfour/supervisor-docker/)

# Installation

## Install Docker.

Download automated build from public Docker Hub Registry: docker pull kdelfour/cloud9-docker

(alternatively, you can build an image from Dockerfile: docker build -t="kdelfour/cloud9-docker" github.com/kdelfour/cloud9-docker)

## Usage

    docker run -it -d -p 80:80 kdelfour/cloud9-docker
    
You can add a workspace as a volume directory with the argument *-v /your-path/workspace/:/workspace/* like this :

    docker run -it -d -p 80:80 -v /your-path/workspace/:/workspace/ kdelfour/cloud9-docker

Also, you can add a test configuration file with the argument *-v /your-path/your-config-file:/cloud9/configs/test-config.js* like this :

    docker run -it -d -p 80:80 -v /your-path/your-config-file:/cloud9/configs/test-config.js kdelfour/cloud9-docker

Or add a test workspace config file with the argument *-v /your-path/your-workspace-config:/cloud9/configs/client-workspace-test.js* like this :

    docker run -it -d -p 80:80 -v /your-path/your-workspace-config:/cloud9/configs/client-workspace-test.js kdelfour/cloud9-docker

If you want to test your own plugins, you can add the top directory of your plugins with the argument *-v /your-path/plugins/:/root/.c9/dev/plugins/* like this :

    docker run -it -d -p 80:80 -v /your-path/plugins/:/root/.c9/dev/plugins/ kdelfour/cloud9-docker
    
## Build and run with custom config directory

Get the latest version from github

    git clone https://github.com/kdelfour/cloud9-docker
    cd cloud9-docker/

Build it

    sudo docker build --force-rm=true --tag="$USER/cloud9-docker:latest" .
    
And run

    sudo docker run -d -p 80:80 \
        -v test-test-config.js:/cloud9/configs/test-config.js \
        -v client-workspace-test.js:/cloud9/configs/client-workspace-test.js \
        -v /your-path/plugins/:/root/.c9/dev/plugins/ \
        -v /your-path/workspace/:/workspace/ $USER/cloud9-docker:latest
    
Enjoy !!    
