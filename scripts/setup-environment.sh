#!/bin/bash

# Script to set up environment variables and configurations for different environments

# Usage: ./setup-environment.sh <environment>
# Example: ./setup-environment.sh dev

set -e

ENVIRONMENT=$1

if [ -z "$ENVIRONMENT" ]; then
    echo "Error: Environment not specified"
    echo "Usage: ./setup-environment.sh <environment>"
    echo "Available environments: dev, test, prod"
    exit 1
fi

if [ ! -f "../config/environments/$ENVIRONMENT.env" ]; then
    echo "Error: Environment file not found for $ENVIRONMENT"
    exit 1
fi

# Load environment variables
export $(cat ../config/environments/$ENVIRONMENT.env | xargs)

# Update manifest files with environment-specific values
echo "Updating manifest files for $ENVIRONMENT environment..."

# Update backend manifest
sed -i "s/TEAMS_APP_ID:.*/TEAMS_APP_ID: $TEAMS_APP_ID/" ../backend/manifest.yaml
sed -i "s/S4HANA_API_URL:.*/S4HANA_API_URL: $S4HANA_API_URL/" ../backend/manifest.yaml
sed -i "s/MICROSOFT_APP_ID:.*/MICROSOFT_APP_ID: $MICROSOFT_APP_ID/" ../backend/manifest.yaml
sed -i "s/MICROSOFT_APP_PASSWORD:.*/MICROSOFT_APP_PASSWORD: $MICROSOFT_APP_PASSWORD/" ../backend/manifest.yaml

# Update Teams app manifest
sed -i "s/\"id\":.*/\"id\": \"$TEAMS_APP_ID\",/" ../teams-app-package/manifest.json
sed -i "s/\"name\":.*/\"name\": \"S4HANA Integration ($ENVIRONMENT)\",/" ../teams-app-package/manifest.json

echo "Environment setup complete for $ENVIRONMENT"