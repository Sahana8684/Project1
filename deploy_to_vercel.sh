#!/bin/bash

# Deploy to Vercel script for College Management System
# This script helps deploy the application to Vercel

# Check if Vercel CLI is installed
if ! command -v vercel &> /dev/null; then
    echo "Vercel CLI is not installed. Installing..."
    npm install -g vercel
fi

# Check if user is logged in to Vercel
echo "Checking if you're logged in to Vercel..."
vercel whoami &> /dev/null
if [ $? -ne 0 ]; then
    echo "You're not logged in to Vercel. Please log in:"
    vercel login
fi

# Prompt for environment variables
echo "Setting up environment variables for deployment..."
echo ""

# SECRET_KEY
read -p "Enter a SECRET_KEY (leave blank for auto-generated): " SECRET_KEY
if [ -z "$SECRET_KEY" ]; then
    SECRET_KEY=$(openssl rand -hex 32)
    echo "Generated SECRET_KEY: $SECRET_KEY"
fi

# Database choice
echo ""
echo "Choose database option:"
echo "1) SQLite In-Memory Database (for demonstration, data will be lost on restart)"
echo "2) PostgreSQL Database (for production, requires connection string)"
read -p "Enter choice [1-2]: " DB_CHOICE

if [ "$DB_CHOICE" == "1" ]; then
    USE_SQLITE_MEMORY="true"
    DATABASE_URL=""
    echo "Using SQLite In-Memory Database"
else
    USE_SQLITE_MEMORY="false"
    read -p "Enter PostgreSQL connection string: " DATABASE_URL
    echo "Using PostgreSQL Database"
fi

# Admin user
echo ""
read -p "Enter admin email (default: admin@example.com): " FIRST_SUPERUSER
FIRST_SUPERUSER=${FIRST_SUPERUSER:-admin@example.com}

read -p "Enter admin password (default: admin): " FIRST_SUPERUSER_PASSWORD
FIRST_SUPERUSER_PASSWORD=${FIRST_SUPERUSER_PASSWORD:-admin}

# Deploy to Vercel
echo ""
echo "Deploying to Vercel..."
vercel deploy \
    --env SECRET_KEY="$SECRET_KEY" \
    --env USE_SQLITE_MEMORY="$USE_SQLITE_MEMORY" \
    --env DATABASE_URL="$DATABASE_URL" \
    --env FIRST_SUPERUSER="$FIRST_SUPERUSER" \
    --env FIRST_SUPERUSER_PASSWORD="$FIRST_SUPERUSER_PASSWORD"

echo ""
echo "Deployment complete! Check the URL above to access your application."
echo "For more information, see the VERCEL_DEPLOYMENT.md file."
