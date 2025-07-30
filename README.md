# BFF (Backend For Frontend) Template

This project is a Backend For Frontend (BFF) template that provides a structured starting point for building backend services that directly support frontend applications. The BFF pattern is designed to optimize the backend API for specific frontend requirements.

## Prerequisites

Before you begin, ensure you have the following installed on your system:

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
   This command will:
   - Set up your project name
   - Create and set up the React frontend
   - Install backend dependencies
   - Configure the Python environment

3. After initialization, set your Python interpreter to the path shown in the terminal output.

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
