# BFF (Backend For Frontend) Template

This project is a Backend For Frontend (BFF) template that provides a structured starting point for building backend services that directly support frontend applications. The BFF pattern is designed to optimize the backend API for specific frontend requirements.

## Prerequisites

Before you begin, ensure you have the following installed on your system:

### Container Runtime and Cloud Tools
- Colima is required for running containers on macOS:
  ```bash
  brew install colima
  colima start
  ```
- Docker is required for containerization:
  ```bash
  brew install docker
  ```
- Google Cloud SDK (required for admin mode):
  ```bash
  brew install google-cloud-sdk
  gcloud init
  gcloud auth configure-docker
  ```
- For more information, visit:
  - [Colima's documentation](https://github.com/abiosoft/colima)
  - [Google Cloud SDK documentation](https://cloud.google.com/sdk/docs)

### Python
- Python 3.8 or higher
- To check your Python version:
  ```bash
  python --version
  ```
- Install Python from [python.org](https://www.python.org/downloads/)

### Poetry (Python Dependency Management)
- Poetry is required for managing Python dependencies
- Install Poetry by running:
  ```bash
  curl -sSL https://install.python-poetry.org | python3 -
  ```
- Verify installation:
  ```bash
  poetry --version
  ```
- For more information, visit [Poetry's documentation](https://python-poetry.org/docs/)

### Node.js and npm
- Node.js 14.x or higher is required for the React frontend
- To check your Node.js version:
  ```bash
  node --version
  npm --version
  ```
- Install Node.js from [nodejs.org](https://nodejs.org/)

### GitHub CLI (gh)
- GitHub CLI is required for managing GitHub secrets and interacting with repositories
- Install GitHub CLI using Homebrew:
  ```bash
  brew install gh
  ```
- Authenticate with GitHub:
  ```bash
  gh auth login
  ```
- Follow the interactive prompts to complete authentication
- For more information, visit [GitHub CLI documentation](https://cli.github.com/)

## Project Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/achsaf6/bff-template
   cd bff-template
   ```

2. Initialize the project:
   ```bash
   make init
   ```
   This command will run the initialization script that:
   - Prompts for deployment type:
     - `local` (default): Sets up local development environment
     - `admin`: Sets up full deployment with GCP service accounts and Docker configuration
   - Prompts for region (default: europe-west4)
   - Updates project name in configuration files
   - Creates and sets up a new React frontend application
   - Installs Python backend dependencies using Poetry
   - Configures CI/CD workflow settings
   
   If running in `admin` mode, it will also:
   - Activate CI/CD workflow
   - Build and push Docker container to Google Container Registry
   - Create and configure GCP service account with necessary permissions
   - Set up GitHub secrets for deployment

3. After initialization, set your Python interpreter to the path shown in the terminal output.
   Note: The init script can only be run once as it self-disables after completion.

## Project Structure

```
bff-template/
├── backend/         # Backend service directory
│   └── main.py     # Main application entry point
├── frontend/        # React frontend application
├── makefile        # Build automation
├── poetry.lock     # Lock file for dependencies
└── pyproject.toml  # Python project configuration
```

## Development

Available make commands:
- `make init` - Initialize the project (first-time setup)
- `make dev` - Run both frontend and backend in development mode
- `make local` - Run backend only
- `make update` - Commit and push changes
- `make test` - Run tests (customizable)

## Contributing

1. Create a new branch for your feature
2. Make your changes
3. Submit a pull request

## License

[Add your license information here]
