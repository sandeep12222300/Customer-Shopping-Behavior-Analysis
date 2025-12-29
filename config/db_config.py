"""
Database Configuration Module

This module provides secure database configuration using environment variables.
Usage:
    from config.db_config import get_db_connection_string
    connection_string = get_db_connection_string()
"""

import os
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()


def get_db_config():
    """
    Retrieve database configuration from environment variables.
    
    Returns:
        dict: Database configuration parameters
    """
    return {
        'username': os.getenv('DB_USERNAME', 'postgres'),
        'password': os.getenv('DB_PASSWORD', ''),
        'host': os.getenv('DB_HOST', 'localhost'),
        'port': os.getenv('DB_PORT', '5432'),
        'database': os.getenv('DB_NAME', 'customer_behavior')
    }


def get_db_connection_string():
    """
    Generate a PostgreSQL connection string for SQLAlchemy.
    
    Returns:
        str: Database connection string in format:
             postgresql://username:password@host:port/database
    """
    config = get_db_config()
    
    if not config['password']:
        raise ValueError(
            "Database password not set. Please set DB_PASSWORD in .env file."
        )
    
    return (
        f"postgresql://{config['username']}:{config['password']}"
        f"@{config['host']}:{config['port']}/{config['database']}"
    )


def validate_db_config():
    """
    Validate that all required database configuration is present.
    
    Returns:
        tuple: (bool, str) - (is_valid, error_message)
    """
    config = get_db_config()
    
    if not config['password']:
        return False, "DB_PASSWORD is not set in environment variables"
    
    if not config['username']:
        return False, "DB_USERNAME is not set in environment variables"
    
    if not config['database']:
        return False, "DB_NAME is not set in environment variables"
    
    return True, "Configuration is valid"
