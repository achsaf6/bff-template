# BFF Template

This is a template for building a web application with a backend and frontend.

## What You Need

Before you start, make sure you have these installed:

1. **Git** - For downloading and managing code
   - Mac users: Usually already installed. Open Terminal and type `git --version` to check.

2. **Python** - For the backend
   - Download from [python.org](https://www.python.org/downloads/)
   - Mac users: You likely already have Python. Check with `python --version`

3. **Node.js** - For the frontend
   - Download from [nodejs.org](https://nodejs.org/)

## Getting Started

### Step 1: Open Cursor

Download and install [Cursor](https://cursor.com/) if you haven't already.

### Step 2: Clone the Repository

1. Open Cursor
2. Click the **Source Control** icon on the left sidebar (looks like a branch)
3. Click **Clone Repository**
4. Paste this URL: `https://github.com/achsaf6/bff-template`
5. Choose a folder on your computer to save it
6. Click **Clone**

### Step 3: Open the Project

After cloning finishes, Cursor will ask if you want to open the repository. Click **Open**.

### Step 4: Initialize the Project

1. Go to the **Terminal** menu at the top
2. Click **New Terminal**
3. A command box will open at the bottom of the screen
4. Type: `make init`
5. Press Enter

Follow any prompts that appear and press Enter for defaults.

### Step 5: Set Python Interpreter

After `make init` finishes, you need to tell Cursor to use the Python environment:

1. Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac) to open the Command Palette
2. Type: `Python: Select Interpreter`
3. Look for an option that shows `.venv` in the path
4. Click on it to select it

### Step 6: Run the Application

1. In the same terminal, type: `make local`
2. Press Enter

When it starts, you'll see messages telling you:
- **Frontend**: Open your browser to `http://localhost:5173`
- **Backend API**: Available at `http://localhost:8000`

### Stopping the Application

Click in the terminal and press `Ctrl+C` to stop everything.

## Alternative: Using Terminal

If you prefer using the terminal instead of Cursor:

### Step 1: Download the Template

```bash
git clone https://github.com/achsaf6/bff-template
cd bff-template
```

### Step 2: Initialize the Project

```bash
make init
```

This command sets up everything automatically. It will:
- Download any required components
- Create the project files
- Install dependencies

Just follow any prompts that appear and press Enter to use the default options.

### Step 3: Set Python Interpreter

After `make init` finishes, you may want to configure your Python IDE. If you're using an IDE like VS Code or Cursor, set the Python interpreter to the `.venv` folder that was created.

### Step 4: Run the Application

To start both the frontend and backend together:

```bash
make local
```

When it starts, you'll see:
- **Frontend**: Open your browser to `http://localhost:5173`
- **Backend API**: Available at `http://localhost:8000`

That's it! Your application is running.

### Stopping the Application

Press `Ctrl+C` in your terminal to stop everything.

## Need Help?

- If something doesn't work, try running the commands again
- Check that you have the correct versions installed by running the version commands above