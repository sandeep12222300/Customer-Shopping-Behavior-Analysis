"""
Configuration package for Customer Shopping Behavior Analysis.

This package contains configuration modules for database connections
and other project settings.
"""

from .db_config import get_db_config, get_db_connection_string, validate_db_config

__all__ = ['get_db_config', 'get_db_connection_string', 'validate_db_config']
