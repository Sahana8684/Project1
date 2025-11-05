@echo off
REM Deploy to Vercel script for College Management System
REM This script helps deploy the application to Vercel

REM Check if Vercel CLI is installed
where vercel >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Vercel CLI is not installed. Installing...
    call npm install -g vercel
)

REM Check if user is logged in to Vercel
echo Checking if you're logged in to Vercel...
vercel whoami >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo You're not logged in to Vercel. Please log in:
    call vercel login
)

REM Prompt for environment variables
echo Setting up environment variables for deployment...
echo.

REM SECRET_KEY
set /p SECRET_KEY="Enter a SECRET_KEY (leave blank for auto-generated): "
if "%SECRET_KEY%"=="" (
    REM Generate a random SECRET_KEY using PowerShell
    for /f "delims=" %%a in ('powershell -Command "[System.Guid]::NewGuid().ToString()"') do set SECRET_KEY=%%a
    echo Generated SECRET_KEY: %SECRET_KEY%
)

REM Database choice
echo.
echo Choose database option:
echo 1) SQLite In-Memory Database (for demonstration, data will be lost on restart)
echo 2) PostgreSQL Database (for production, requires connection string)
set /p DB_CHOICE="Enter choice [1-2]: "

if "%DB_CHOICE%"=="1" (
    set USE_SQLITE_MEMORY=true
    set DATABASE_URL=
    echo Using SQLite In-Memory Database
) else (
    set USE_SQLITE_MEMORY=false
    set /p DATABASE_URL="Enter PostgreSQL connection string: "
    echo Using PostgreSQL Database
)

REM Admin user
echo.
set /p FIRST_SUPERUSER="Enter admin email (default: admin@example.com): "
if "%FIRST_SUPERUSER%"=="" set FIRST_SUPERUSER=admin@example.com

set /p FIRST_SUPERUSER_PASSWORD="Enter admin password (default: admin): "
if "%FIRST_SUPERUSER_PASSWORD%"=="" set FIRST_SUPERUSER_PASSWORD=admin

REM Deploy to Vercel
echo.
echo Deploying to Vercel...
call vercel deploy ^
    --env SECRET_KEY="%SECRET_KEY%" ^
    --env USE_SQLITE_MEMORY="%USE_SQLITE_MEMORY%" ^
    --env DATABASE_URL="%DATABASE_URL%" ^
    --env FIRST_SUPERUSER="%FIRST_SUPERUSER%" ^
    --env FIRST_SUPERUSER_PASSWORD="%FIRST_SUPERUSER_PASSWORD%"

echo.
echo Deployment complete! Check the URL above to access your application.
echo For more information, see the VERCEL_DEPLOYMENT.md file.
pause
