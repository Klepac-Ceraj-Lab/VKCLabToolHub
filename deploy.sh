#!/bin/bash
docker build . -t vkctoolhub:latest

docker run -d -p 3838:3838 vkctoolhub:latest