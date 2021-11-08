#!/bin/bash

DOCKERUSER=restlessronin
docker manifest create ${USER}/phoenix:ma-$1 --amend ${DOCKERUSER}/phoenix:amd64-$1 --amend ${DOCKERUSER}/phoenix:arm64-$1
