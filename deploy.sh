#!/bin/bash
set -e

CONTAINER_NAME=react-app
IMAGE_NAME=react-app:latest

echo "Stopping existing container..."

docker rm -f ${CONTAINER_NAME} || true

echo "Starting new container..."
docker run -d \
  --name ${CONTAINER_NAME} \
  -p 80:80 \
  --restart unless-stopped \
  ${IMAGE_NAME}

echo "Deployment completed successfully"