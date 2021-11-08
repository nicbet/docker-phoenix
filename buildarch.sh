#!/bin/bash
DOCKERUSER=restlessronin
docker buildx build --push --platform linux/$1 -t ${DOCKERUSER}/phoenix:$1-$2 .
