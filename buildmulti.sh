#!/bin/bash

docker manifest create nicbet/phoenix:$1 --amend nicbet/phoenix:amd64-$1 --amend nicbet/phoenix:arm64-$1
docker manifest push nicbet/phoenix:$1 
