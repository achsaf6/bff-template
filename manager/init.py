"""
Local development initialization.
"""

import subprocess
from pathlib import Path

from .config import ProjectConfig
from .manifest import ManifestManager


class InitManager:
    """Manages local development initialization."""
    
    def __init__(self, config: ProjectConfig, manifest: ManifestManager):
        self.config = config
        self.manifest = manifest
    
    def update_project_files(self) -> bool:
        """Update project name in configuration files."""
        try:
            print("Updating project name in configuration files...")
            
            # Update pyproject.toml
            if self.config.pyproject_file.exists():
                content = self.config.pyproject_file.read_text()
                content = content.replace(
                    'name = "bff-template"',
                    f'name = "{self.config.project_name}"'
                )
                self.config.pyproject_file.write_text(content)
            
            # Update makefile
            if self.config.makefile.exists():
                content = self.config.makefile.read_text()
                content = content.replace(
                    'name = "bff-template"',
                    f'name = "{self.config.project_name}"'
                )
                self.config.makefile.write_text(content)
            
            print("✓ Configuration files updated")
            return True
        except Exception as e:
            print(f"Error updating project files: {e}")
            return False
    
    def setup_frontend(self, skip_build: bool = False) -> bool:
        """Setup the frontend React application."""
        try:
            print("Setting up frontend...")
            
            # Create frontend directory if it doesn't exist
            self.config.frontend_dir.mkdir(parents=True, exist_ok=True)
            
            # Check if frontend is already initialized
            package_json = self.config.frontend_dir / "package.json"
            if package_json.exists():
                print("Frontend already initialized")
                
                if not skip_build:
                    print("Building frontend...")
                    subprocess.run(
                        ["npm", "run", "build"],
                        cwd=self.config.frontend_dir,
                        check=True
                    )
            else:
                # Initialize React app
                print("Creating React app (this may take a few minutes)...")
                subprocess.run(
                    ["npx", "create-react-app", ".", "--yes"],
                    cwd=self.config.frontend_dir,
                    check=True
                )
                
                if not skip_build:
                    print("Building frontend...")
                    subprocess.run(
                        ["npm", "run", "build"],
                        cwd=self.config.frontend_dir,
                        check=True
                    )
            
            print("✓ Frontend setup complete")
            return True
        except subprocess.CalledProcessError as e:
            print(f"Error setting up frontend: {e}")
            return False
    
    def setup_backend(self) -> bool:
        """Setup the backend Python dependencies."""
        try:
            print("Setting up backend dependencies...")
            
            # Use uv to sync dependencies
            subprocess.run(["uv", "sync"], cwd=self.config.project_root, check=True)
            
            print("✓ Backend setup complete")
            return True
        except subprocess.CalledProcessError as e:
            print(f"Error setting up backend: {e}")
            return False
    
    def initialize(self, skip_frontend_build: bool = False) -> bool:
        """Run full local initialization."""
        print(f"Initializing project: {self.config.project_name}")
        print("")
        
        # Check if already initialized
        if self.manifest.get_state("initialized"):
            print("⚠️  Project is already initialized")
            response = input("Do you want to re-initialize? (y/N): ")
            if response.lower() not in ['y', 'yes']:
                return False
        
        # Create .env file
        self.config.ensure_env_file()
        print("✓ .env file created")
        
        # Update configuration files
        if not self.update_project_files():
            return False
        
        # Setup frontend
        if not self.setup_frontend(skip_build=skip_frontend_build):
            return False
        
        # Setup backend
        if not self.setup_backend():
            return False
        
        # Update manifest
        self.manifest.update_state("initialized", True)
        self.manifest.update_config("project_name", self.config.project_name)
        self.manifest.log_operation("init", {"type": "local"})
        
        print("")
        print("=" * 50)
        print("Local development setup complete!")
        print("=" * 50)
        print("")
        print("Next steps:")
        print(f"  1. Set your Python interpreter to: .venv")
        print(f"  2. Run 'make local' to start the development server")
        print("")
        return True