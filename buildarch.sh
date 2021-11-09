#!/bin/bash

docker buildx build --push --platform linux/$1 -t nicbet/phoenix:$1-$2 .
