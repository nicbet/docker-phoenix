#!/bin/bash
docker build -t nicbet/phoenix:$1 .
docker push nicbet/phoenix:$1
docker tag nicbet/phoenix:$1 nicbet/phoenix:latest
docker push nicbet/phoenix:latest
