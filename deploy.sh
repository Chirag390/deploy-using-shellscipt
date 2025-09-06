#!/bin/bash
set -e

APP_NAME="portfolio"
DOCKER_USER="your-dockerhub-username"   # change this
REPO_PATH="/home/chirag390/portfolio-deveops"

cd $REPO_PATH || exit

echo "🚀 Pulling latest code..."
git pull origin main || exit 1

echo "🧪 Running tests..."
pytest || { echo "❌ Tests failed. Deployment stopped."; exit 1; }

COMMIT_HASH=$(git rev-parse --short HEAD)
IMAGE_NAME="$DOCKER_USER/$APP_NAME:$COMMIT_HASH"

echo "🐳 Building Docker image..."
docker build -t $IMAGE_NAME .

echo "🛑 Stopping old container..."
docker stop $APP_NAME 2>/dev/null || true
docker rm $APP_NAME 2>/dev/null || true

echo "▶️ Starting new container..."
docker run -d --name $APP_NAME -p 5000:5000 $IMAGE_NAME

echo "☁️ Pushing image to Docker Hub..."
docker push $IMAGE_NAME

echo "✅ Deployment complete! App running at http://localhost:5000"

