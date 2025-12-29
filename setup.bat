@echo off
REM ============================================
REM Customer Shopping Behavior Analysis
REM Setup Script for Windows
REM ============================================

echo ==================================
echo Customer Behavior Analysis Setup
echo ==================================
echo.

REM Check Python installation
echo Checking Python installation...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python is not installed
    echo Please install Python 3.8 or higher from https://www.python.org/
    pause
    exit /b 1
)
python --version
echo [OK] Python found

REM Check pip installation
echo Checking pip installation...
pip --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] pip is not installed
    pause
    exit /b 1
)
echo [OK] pip found

echo.
REM Create virtual environment
echo Creating virtual environment...
if exist venv (
    echo [WARNING] Virtual environment already exists
    set /p RECREATE="Do you want to recreate it? (y/n): "
    if /i "%RECREATE%"=="y" (
        rmdir /s /q venv
        python -m venv venv
        echo [OK] Virtual environment recreated
    )
) else (
    python -m venv venv
    echo [OK] Virtual environment created
)

echo.
REM Activate virtual environment
echo Activating virtual environment...
call venv\Scripts\activate.bat

echo.
REM Upgrade pip
echo Upgrading pip...
python -m pip install --upgrade pip --quiet
echo [OK] pip upgraded

echo.
REM Install dependencies
echo Installing Python dependencies...
echo This may take a few minutes...
pip install -r requirements.txt --quiet
if %errorlevel% neq 0 (
    echo [ERROR] Failed to install dependencies
    pause
    exit /b 1
)
echo [OK] Dependencies installed successfully

echo.
REM Create .env file if it doesn't exist
if not exist .env (
    echo Creating .env file from template...
    copy .env.example .env >nul
    echo [OK] .env file created
    echo [WARNING] Please update .env file with your database credentials
) else (
    echo [WARNING] .env file already exists
)

echo.
REM Verify installation
echo Verifying installation...
python -c "import pandas; import sklearn; import psycopg2; print('All packages imported successfully!')" 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Package verification failed
    pause
    exit /b 1
)
echo [OK] All packages verified

echo.
echo ==================================
echo Setup completed successfully!
echo ==================================
echo.
echo Next steps:
echo 1. Activate the virtual environment:
echo    venv\Scripts\activate
echo.
echo 2. Update .env file with your database credentials
echo.
echo 3. Launch Jupyter Notebook:
echo    jupyter notebook
echo.
echo 4. Open notebooks/Customer_Behavior_Analysis.ipynb
echo.
echo For more information, see:
echo - README.md
echo - docs/INSTALLATION.md
echo ==================================
echo.
pause
