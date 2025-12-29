#!/bin/bash

# ============================================
# Customer Shopping Behavior Analysis
# Setup Script for Unix-based Systems
# ============================================

echo "=================================="
echo "Customer Behavior Analysis Setup"
echo "=================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check Python installation
echo "Checking Python installation..."
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version)
    echo -e "${GREEN}✓${NC} $PYTHON_VERSION found"
else
    echo -e "${RED}✗${NC} Python 3 is not installed"
    echo "Please install Python 3.8 or higher from https://www.python.org/"
    exit 1
fi

# Check pip installation
echo "Checking pip installation..."
if command -v pip3 &> /dev/null; then
    echo -e "${GREEN}✓${NC} pip3 found"
else
    echo -e "${RED}✗${NC} pip3 is not installed"
    exit 1
fi

# Create virtual environment
echo ""
echo "Creating virtual environment..."
if [ -d "venv" ]; then
    echo -e "${YELLOW}!${NC} Virtual environment already exists"
    read -p "Do you want to recreate it? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf venv
        python3 -m venv venv
        echo -e "${GREEN}✓${NC} Virtual environment recreated"
    fi
else
    python3 -m venv venv
    echo -e "${GREEN}✓${NC} Virtual environment created"
fi

# Activate virtual environment
echo ""
echo "Activating virtual environment..."
source venv/bin/activate

# Upgrade pip
echo ""
echo "Upgrading pip..."
pip install --upgrade pip --quiet
echo -e "${GREEN}✓${NC} pip upgraded"

# Install dependencies
echo ""
echo "Installing Python dependencies..."
echo "This may take a few minutes..."
pip install -r requirements.txt --quiet
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${NC} Dependencies installed successfully"
else
    echo -e "${RED}✗${NC} Failed to install dependencies"
    exit 1
fi

# Create .env file if it doesn't exist
echo ""
if [ ! -f ".env" ]; then
    echo "Creating .env file from template..."
    cp .env.example .env
    echo -e "${GREEN}✓${NC} .env file created"
    echo -e "${YELLOW}!${NC} Please update .env file with your database credentials"
else
    echo -e "${YELLOW}!${NC} .env file already exists"
fi

# Verify installation
echo ""
echo "Verifying installation..."
python3 -c "import pandas; import sklearn; import psycopg2; print('All packages imported successfully!')" 2>/dev/null
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${NC} All packages verified"
else
    echo -e "${RED}✗${NC} Package verification failed"
    exit 1
fi

# Summary
echo ""
echo "=================================="
echo "Setup completed successfully! 🎉"
echo "=================================="
echo ""
echo "Next steps:"
echo "1. Activate the virtual environment:"
echo "   source venv/bin/activate"
echo ""
echo "2. Update .env file with your database credentials"
echo ""
echo "3. Launch Jupyter Notebook:"
echo "   jupyter notebook"
echo ""
echo "4. Open notebooks/Customer_Behavior_Analysis.ipynb"
echo ""
echo "For more information, see:"
echo "- README.md"
echo "- docs/INSTALLATION.md"
echo "=================================="
