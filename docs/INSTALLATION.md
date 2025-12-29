# Installation Guide

This guide provides detailed instructions for setting up the Customer Shopping Behavior Analysis project.

## Table of Contents
1. [System Requirements](#system-requirements)
2. [Installation Steps](#installation-steps)
3. [Database Setup](#database-setup)
4. [Verification](#verification)
5. [Troubleshooting](#troubleshooting)

---

## System Requirements

### Required Software
- **Python**: Version 3.8 or higher
- **pip**: Python package manager (usually included with Python)
- **Git**: For cloning the repository
- **PostgreSQL**: Version 12 or higher (optional, for database integration)
- **Power BI Desktop**: For viewing dashboards (Windows only)

### Hardware Requirements
- **RAM**: Minimum 4GB, recommended 8GB+
- **Storage**: At least 500MB free space
- **Processor**: Any modern multi-core processor

### Supported Operating Systems
- Windows 10/11
- macOS 10.14+
- Linux (Ubuntu 18.04+, Fedora, CentOS, etc.)

---

## Installation Steps

### Step 1: Clone the Repository

```bash
# Clone the repository
git clone https://github.com/sandeep12222300/Customer-Shopping-Behavior-Analysis.git

# Navigate to the project directory
cd Customer-Shopping-Behavior-Analysis
```

### Step 2: Create a Virtual Environment (Recommended)

Using a virtual environment isolates project dependencies from your system Python.

**On Windows:**
```bash
# Create virtual environment
python -m venv venv

# Activate virtual environment
venv\Scripts\activate
```

**On macOS/Linux:**
```bash
# Create virtual environment
python3 -m venv venv

# Activate virtual environment
source venv/bin/activate
```

You should see `(venv)` in your terminal prompt indicating the virtual environment is active.

### Step 3: Install Python Dependencies

```bash
# Upgrade pip to the latest version
pip install --upgrade pip

# Install all required packages
pip install -r requirements.txt
```

This will install:
- pandas (data manipulation)
- numpy (numerical computing)
- scikit-learn (machine learning)
- matplotlib & seaborn (visualization)
- psycopg2-binary (PostgreSQL connector)
- sqlalchemy (database ORM)
- jupyter (notebook environment)

### Step 4: Verify Installation

```bash
# Check Python version
python --version

# Check installed packages
pip list

# Verify key packages
python -c "import pandas; import sklearn; import psycopg2; print('All packages installed successfully!')"
```

---

## Database Setup

### Option 1: Skip Database (Recommended for Quick Start)

You can run the analysis without setting up a database. The notebook will:
- Read data from CSV files
- Perform all analysis
- Generate visualizations
- Export results to CSV

Simply skip to [Verification](#verification) section.

### Option 2: Set Up PostgreSQL Database

#### 1. Install PostgreSQL

**On Windows:**
- Download from [postgresql.org](https://www.postgresql.org/download/)
- Run the installer
- Note the password you set for the `postgres` user

**On macOS:**
```bash
# Using Homebrew
brew install postgresql
brew services start postgresql
```

**On Linux (Ubuntu/Debian):**
```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

#### 2. Create Database

```bash
# Access PostgreSQL
psql -U postgres

# In PostgreSQL shell, create database
CREATE DATABASE customer_behavior;

# Exit PostgreSQL shell
\q
```

#### 3. Configure Database Connection

```bash
# Copy the environment template
cp .env.example .env

# Edit .env file with your credentials
# Update the following:
# DB_USERNAME=postgres
# DB_PASSWORD=your_actual_password
# DB_HOST=localhost
# DB_PORT=5432
# DB_NAME=customer_behavior
```

**Validation:** After updating `.env`, verify the configuration:
```bash
# Check that .env file exists and has required variables
grep -q "DB_PASSWORD=" .env && echo "✓ .env configured" || echo "✗ .env needs configuration"
```

**Important**: Never commit `.env` file to version control!

#### 4. Test Database Connection

```python
# In Python or Jupyter
from config.db_config import get_db_connection_string, validate_db_config

# Validate configuration
is_valid, message = validate_db_config()
print(message)

# Test connection
from sqlalchemy import create_engine
engine = create_engine(get_db_connection_string())
print("Database connection successful!")
```

---

## Verification

### 1. Launch Jupyter Notebook

```bash
# Make sure virtual environment is activated
jupyter notebook
```

Your browser should open automatically to the Jupyter interface.

### 2. Open the Analysis Notebook

1. Navigate to `notebooks/`
2. Click on `Customer_Behavior_Analysis.ipynb`
3. Run the first few cells to verify everything works

### 3. Quick Test

```python
# In a Jupyter cell or Python script
import pandas as pd
import numpy as np
from sklearn.cluster import KMeans

# Load data
df = pd.read_csv('data/customer_shopping_behavior.csv')
print(f"Dataset loaded successfully: {df.shape[0]} rows, {df.shape[1]} columns")
print(df.head())
```

---

## Troubleshooting

### Issue: Python not found

**Solution:**
- Ensure Python 3.8+ is installed
- Check PATH environment variable
- Try using `python3` instead of `python`

### Issue: pip install fails

**Solution:**
```bash
# Upgrade pip
python -m pip install --upgrade pip

# If specific package fails, install separately
pip install pandas
pip install scikit-learn
```

### Issue: PostgreSQL connection error

**Solution:**
- Verify PostgreSQL is running: `pg_isready`
- Check credentials in `.env` file
- Ensure database exists: `psql -U postgres -l`
- Check firewall/port 5432

### Issue: Jupyter notebook doesn't open

**Solution:**
```bash
# Reinstall jupyter
pip uninstall jupyter notebook
pip install jupyter notebook

# Try with specific IP
jupyter notebook --ip=127.0.0.1
```

### Issue: ImportError for psycopg2

**Solution:**
```bash
# On Linux, install system dependencies first
sudo apt-get install libpq-dev python3-dev

# Then reinstall
pip install psycopg2-binary
```

### Issue: Permission denied on macOS/Linux

**Solution:**
```bash
# Use pip with --user flag
pip install --user -r requirements.txt

# Or fix permissions
sudo chown -R $USER:$USER ~/path/to/project
```

---

## Next Steps

After successful installation:

1. **Run the Analysis**: Open and run `notebooks/Customer_Behavior_Analysis.ipynb`
2. **Explore SQL Queries**: Check `sql/customer_behavior_sql_queries.sql`
3. **View Dashboards**: Open `.pbix` files in Power BI Desktop
4. **Read Documentation**: Explore `docs/` for more information

---

## Getting Help

If you encounter issues not covered here:

1. Check [GitHub Issues](https://github.com/sandeep12222300/Customer-Shopping-Behavior-Analysis/issues)
2. Review [CONTRIBUTING.md](../CONTRIBUTING.md)
3. Open a new issue with:
   - Your operating system
   - Python version
   - Error message
   - Steps to reproduce

---

## Uninstallation

To remove the project:

```bash
# Deactivate virtual environment
deactivate

# Remove project directory
cd ..
rm -rf Customer-Shopping-Behavior-Analysis

# Optional: Remove PostgreSQL database
psql -U postgres -c "DROP DATABASE customer_behavior;"
```

Happy analyzing! 🎉
