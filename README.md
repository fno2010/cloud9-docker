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

You can mount several volumes to customize the docker. Exactly, you can mount the following volumes:

- Mount your own workspace with the argument `-v /your-path/workspace/:/workspace/`
- Mount your own configuration file with the argument `-v /your-path/your-config-file:/cloud9/configs/test-config.js`
- Mount your own workspace configuration file with the argument `-v /your-path/your-workspace-config:/cloud9/configs/client-workspace-test.js`
- Mount your own plugin with the argument `-v /your-path/your-plugin:/cloud9/plugins/your-plugin`

## Build and run with custom config directory

Get the latest version from github

    git clone https://github.com/kdelfour/cloud9-docker
    cd cloud9-docker/

Build it

    sudo ./build.sh

And run

    sudo ./run.sh

It will create a directory named `workspace` under the current path and mount it as the cloud9 workspace.

If you want to add your own plugins, you can easily copy your plugin directories into the `plugins` directory under the repo top path. If you want to add your own configuration files, you can copy `test-config.js` and `client-workspace-test.js` into `conf` directory under the repo top path and modify the content.

Enjoy !!
