# Deploying the College Management System to Vercel

This guide will walk you through the process of deploying the College Management System to Vercel.

## Prerequisites

1. A [Vercel](https://vercel.com/) account
2. [Git](https://git-scm.com/) installed on your local machine
3. (Optional) A PostgreSQL database - only needed if you want persistent data storage. The application can run with an in-memory SQLite database for demonstration purposes.

## Step 1: Prepare Your Project

The project has already been configured for Vercel deployment with the following files:

- `vercel.json`: Configuration file for Vercel
- `api/index.py`: Entry point for Vercel's serverless functions
- `.env.example`: Example environment variables

## Step 2: Set Up a PostgreSQL Database

1. Create a PostgreSQL database using your preferred provider
2. Note down the connection string, which should look like:
   ```
   postgresql://username:password@hostname:port/database
   ```

## Step 3: Deploy to Vercel

### Option 1: Using the Deployment Scripts (Recommended)

We've included deployment scripts to make the process easier:

- For Linux/Mac users:
  ```bash
  chmod +x deploy_to_vercel.sh
  ./deploy_to_vercel.sh
  ```

- For Windows users:
  ```
  deploy_to_vercel.bat
  ```

These scripts will:
1. Check if Vercel CLI is installed and install it if needed
2. Verify you're logged in to Vercel
3. Guide you through setting up environment variables
4. Deploy the application to Vercel

### Option 2: Deploy via Vercel CLI Manually

1. Install the Vercel CLI:
   ```bash
   npm install -g vercel
   ```

2. Login to Vercel:
   ```bash
   vercel login
   ```

3. Deploy the project:
   ```bash
   vercel
   ```

4. Follow the prompts to configure your project

### Option 3: Deploy via Vercel Dashboard

1. Push your code to a Git repository (GitHub, GitLab, or Bitbucket)
2. Log in to your Vercel account
3. Click "New Project"
4. Import your repository
5. Configure the project:
   - Framework Preset: Other
   - Root Directory: `./`
   - Build Command: `pip install -r requirements.txt`
   - Output Directory: N/A
   - Install Command: N/A

## Step 4: Configure Environment Variables

In the Vercel dashboard, go to your project settings and add the following environment variables:

### Option 1: Using SQLite In-Memory Database (for demonstration)

- `SECRET_KEY`: A secure random string for JWT encryption
- `USE_SQLITE_MEMORY`: Set to `true`
- `FIRST_SUPERUSER`: Email for the first admin user (default: admin@example.com)
- `FIRST_SUPERUSER_PASSWORD`: Password for the first admin user (default: admin)

With this configuration, the application will use an in-memory SQLite database. This is perfect for demonstration purposes, but be aware that:
- Data will be lost whenever the serverless function restarts
- Each serverless function instance will have its own separate database
- Sample data will be created automatically on startup

### Option 2: Using PostgreSQL Database (for production)

- `SECRET_KEY`: A secure random string for JWT encryption
- `USE_SQLITE_MEMORY`: Set to `false`
- `DATABASE_URL`: Your PostgreSQL connection string
- `FIRST_SUPERUSER`: Email for the first admin user
- `FIRST_SUPERUSER_PASSWORD`: Password for the first admin user

You can copy these from the `.env.example` file and update them with your values.

## Step 5: Verify Deployment

1. Once deployed, Vercel will provide you with a URL for your application
2. Visit the URL to ensure the application is running correctly
3. Test the API endpoints by visiting `/api` to see the welcome message
4. Log in with the admin credentials you set in the environment variables

## Troubleshooting

If you encounter any issues during deployment, check the following:

1. Vercel logs: In the Vercel dashboard, go to your project and check the deployment logs
2. Database connection: Ensure your database connection string is correct and the database is accessible from Vercel
3. Environment variables: Make sure all required environment variables are set correctly

## Additional Resources

- [Vercel Documentation](https://vercel.com/docs)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [SQLAlchemy Documentation](https://docs.sqlalchemy.org/)
