#!/bin/bash

docker build --force-rm=true --tag="$(echo $USER | tr '[:upper:]' '[:lower:]')/cloud9-docker:latest" .
