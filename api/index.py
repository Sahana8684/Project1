import os
import sys

# Set VERCEL environment variable to indicate we're running in Vercel
os.environ["VERCEL"] = "1"

# Set USE_SQLITE_MEMORY to true by default for Vercel
if "USE_SQLITE_MEMORY" not in os.environ:
    os.environ["USE_SQLITE_MEMORY"] = "true"

# Add the parent directory to sys.path to allow imports from the school_management_system package
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))

# Set default environment variables if not already set
if "SECRET_KEY" not in os.environ:
    os.environ["SECRET_KEY"] = "vercel-deployment-secret-key"

if "FIRST_SUPERUSER" not in os.environ:
    os.environ["FIRST_SUPERUSER"] = "admin@example.com"

if "FIRST_SUPERUSER_PASSWORD" not in os.environ:
    os.environ["FIRST_SUPERUSER_PASSWORD"] = "admin"

try:
    # Apply bcrypt patch before importing any other modules
    from school_management_system.utils.bcrypt_patch import apply_patch
    apply_patch()

    # Import the FastAPI app
    from school_management_system.main import app

    # This is necessary for Vercel serverless functions
    handler = app
except Exception as e:
    from fastapi import FastAPI, Request
    from fastapi.responses import JSONResponse
    
    # Create a minimal app for error reporting
    app = FastAPI()
    
    @app.get("/")
    async def error_root():
        return {"error": str(e), "message": "Error initializing application"}
    
    @app.get("/{path:path}")
    async def catch_all(request: Request, path: str):
        return JSONResponse(
            status_code=500,
            content={
                "error": str(e),
                "message": "Error initializing application",
                "path": path,
                "query_params": str(request.query_params)
            }
        )
    
    handler = app
