#!/bin/bash

sudo docker build --force-rm=true --tag="$USER/cloud9-docker:latest" .
