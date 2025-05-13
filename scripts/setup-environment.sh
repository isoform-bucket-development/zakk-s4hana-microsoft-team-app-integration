#!/bin/bash

# Setup script for configuring deployment environments

# Check if environment parameter is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <environment>"
    echo "Environment can be: dev, test, or prod"
    exit 1
fi

ENV=$1
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$SCRIPT_DIR/.."
ENV_FILE="$PROJECT_ROOT/config/environments/$ENV.env"

# Check if environment file exists
if [ ! -f "$ENV_FILE" ]; then
    echo "Error: Environment file $ENV_FILE not found"
    exit 1
fi

# Load environment variables
export $(cat "$ENV_FILE" | xargs)

# Install dependencies
echo "Installing backend dependencies..."
cd "$PROJECT_ROOT/backend"
npm ci

echo "Installing frontend dependencies..."
cd "$PROJECT_ROOT/frontend"
npm ci

# Build frontend
echo "Building frontend..."
npm run build

# Package Teams app
echo "Packaging Teams app..."
cd "$PROJECT_ROOT/teams-app-package"
./compress-app.sh

echo "Environment $ENV setup complete!"