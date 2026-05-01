#!/bin/bash
set -e

IMAGE_NAME=react-app
TAG=$(git rev-parse --short HEAD)

echo "Building Docker image..."
docker build -t ${IMAGE_NAME}:${TAG} .
docker tag ${IMAGE_NAME}:${TAG} ${IMAGE_NAME}:latest

echo "Build completed successfully"