DevOpen Docker Repo
===================

This repository contains Dockerfile of DevOpen IDE for Docker's automated build published to the public Docker Hub Registry.

# Base Docker Image
[kdelfour/supervisor-docker](https://registry.hub.docker.com/u/kdelfour/supervisor-docker/)

# Installation

## Install Docker

Download automated build from public Docker Hub Registry: docker pull fno2010/devopen

(alternatively, you can build an image from Dockerfile: docker build -t="fno2010/devopen" github.com/fno2010/cloud9-docker)

## Quick Start

Download plugins into `plugins` directory:

    pushd plugins/
    git clone https://github.com/snlab/snlab.devopen.newresource
    git clone https://github.com/snlab/snlab.devopen.controller
    git clone https://github.com/snlab/snlab.devopen.server
    git clone https://github.com/snlab/snlab.devopen.topoeditor
    git clone https://github.com/snlab/snlab.devopen.favicon
    git clone https://github.com/snlab/snlab.devopen.layout
    popd

Start a docker instance:

    ./run.sh

## Usage

> **WARN:** this part is out-of-date. Please refer to Quick Start.

    docker run -it -d -p 80:80 fno2010/devopen

You can mount several volumes to customize the docker. Exactly, you can mount the following volumes:

- Mount your own workspace with the argument `-v /your-path/workspace/:/workspace/`
- Mount your own configuration file with the argument `-v /your-path/your-config-file:/cloud9/configs/test-config.js`
- Mount your own workspace configuration file with the argument `-v /your-path/your-workspace-config:/cloud9/configs/client-workspace-test.js`
- Mount your own plugin with the argument `-v /your-path/your-plugin:/cloud9/plugins/your-plugin`

## Build and run with custom config directory

Get the latest version from github

    git clone https://github.com/fno2010/cloud9-docker
    cd cloud9-docker/

Build it

    sudo ./build.sh

And run

    sudo ./run.sh

It will create a directory named `workspace` under the current path and mount it as the cloud9 workspace.

If you want to add your own plugins, you can easily copy your plugin directories into the `plugins` directory under the repo top path. If you want to add your own configuration files, you can copy `test-config.js` and `client-workspace-test.js` into `conf` directory under the repo top path and modify the content.

Enjoy !!

## Acknowledgement

This repo is forked from [kdelfour/cloud9-docker](https://github.com/kdelfour/cloud9-docker).
