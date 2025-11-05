import os
import sys

# Set VERCEL environment variable to indicate we're running in Vercel
os.environ["VERCEL"] = "1"

# Set USE_SQLITE_MEMORY to true by default for Vercel
if "USE_SQLITE_MEMORY" not in os.environ:
    os.environ["USE_SQLITE_MEMORY"] = "true"

# Add the parent directory to sys.path to allow imports from the school_management_system package
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))

# Apply bcrypt patch before importing any other modules
from school_management_system.utils.bcrypt_patch import apply_patch
apply_patch()

# Import the FastAPI app
from school_management_system.main import app

# This is necessary for Vercel serverless functions
handler = app
