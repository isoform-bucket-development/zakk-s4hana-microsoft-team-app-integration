# CI/CD Pipeline Documentation

This document describes the Continuous Integration and Continuous Deployment (CI/CD) pipeline implemented for the SAP S/4HANA Microsoft Teams Integration application.

## Pipeline Overview

The pipeline is implemented using GitHub Actions and consists of the following stages:

1. Build and Test
2. Package Teams App
3. Deploy to Development
4. Deploy to Test
5. Deploy to Production

### Pipeline Stages

#### 1. Build and Test
- Builds both frontend and backend applications
- Runs unit tests for the frontend
- Performs security audit on dependencies
- Creates artifacts for deployment

#### 2. Package Teams App
- Packages the Microsoft Teams application
- Creates a deployable ZIP file
- Stores the package as an artifact

#### 3. Deploy to Development (dev)
- Automatically triggered after successful build and package
- Deploys backend and frontend to development environment
- Uses development-specific configuration
- No manual approval required

#### 4. Deploy to Test (test)
- Triggered after successful deployment to development
- Only runs on the main branch
- Uses test environment configuration
- Requires environment approval

#### 5. Deploy to Production (prod)
- Final deployment stage
- Only runs on the main branch
- Requires production environment approval
- Uses production configuration

## Environment Configuration

The pipeline uses environment-specific configuration files located in `config/environments/`:
- `dev.env`: Development environment configuration
- `test.env`: Test environment configuration
- `prod.env`: Production environment configuration

## Required Secrets

The following secrets need to be configured in GitHub:

- `CF_USERNAME`: Cloud Foundry username
- `CF_PASSWORD`: Cloud Foundry password
- `CF_ORG`: Cloud Foundry organization
- `CF_API`: Cloud Foundry API endpoint

## Deployment Process

The deployment process uses Cloud Foundry CLI to deploy the application:

1. Backend Deployment:
   - Uses manifest.yaml with environment-specific variables
   - Deploys Node.js application
   - Configures environment variables

2. Frontend Deployment:
   - Deploys built React application
   - Uses environment-specific configuration
   - Sets up routing and services

## Teams App Package

The Teams app package is created using the `compress-app.sh` script in the teams-app-package directory. The package includes:
- Manifest file
- Icons
- Required configurations

## Security Considerations

The pipeline includes several security measures:
- Dependency security scanning
- Environment-specific secrets
- Approval gates for test and production deployments
- Secure secret management through GitHub Actions

## Monitoring and Logging

- Application logs are configured based on environment
- Cloud Foundry logging is enabled
- Environment-specific log levels are configured

## Rollback Process

To rollback a deployment:
1. Use the Cloud Foundry CLI to revert to the previous version
2. Update the Teams app package if necessary
3. Deploy the previous version through the pipeline

## Best Practices

1. Always create feature branches for new development
2. Use meaningful commit messages
3. Keep secrets secure and never commit them to the repository
4. Review logs after each deployment
5. Test changes in development before promoting to test/production

## Troubleshooting

Common issues and solutions:
1. Build Failures:
   - Check Node.js version compatibility
   - Verify all dependencies are available
   - Check for test failures

2. Deployment Failures:
   - Verify Cloud Foundry credentials
   - Check service bindings
   - Review environment configurations

3. Teams App Package Issues:
   - Verify manifest.json configuration
   - Check icon files
   - Validate app ID and other required fields