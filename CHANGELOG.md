# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2024-12-29

### Added
- Comprehensive documentation in `docs/` directory
  - INSTALLATION.md - Detailed setup guide with troubleshooting
  - DATA_DICTIONARY.md - Complete dataset documentation
  - ANALYSIS_GUIDE.md - Analytical methodology and business insights
  - DATABASE.md - PostgreSQL integration and security guide
- Security documentation (SECURITY.md)
- Contributing guidelines (CONTRIBUTING.md)
- Code of Conduct (CODE_OF_CONDUCT.md)
- Automated setup scripts (setup.sh for Linux/macOS, setup.bat for Windows)
- Configuration module for secure database credentials (config/db_config.py)
- Environment variable template (.env.example)
- Python dependency specifications (requirements.txt)
- Git ignore rules (.gitignore)
- GitHub Actions CI workflow for automated testing
- README files for notebooks/ and sql/ directories
- Enhanced README.md with badges, quick start, and better structure
- CHANGELOG.md for version tracking

### Changed
- Enhanced SQL queries with detailed comments and documentation
- Improved README.md with comprehensive project documentation
- Updated project structure to follow best practices

### Security
- Added secure credential management using environment variables
- Created database configuration module to prevent hardcoded passwords
- Documented security best practices in SECURITY.md
- Added dependency security scanning in CI pipeline
- Verified no vulnerabilities in current dependencies

## [1.0.0] - 2024-01-01

### Added
- Initial release of Customer Shopping Behavior Analysis
- Jupyter notebook with complete analysis pipeline
- K-Means clustering for customer segmentation
- SQL queries for business intelligence
- Power BI dashboards for data visualization
- Customer behavior dataset
- ML-enhanced dataset with segmentation
- Project presentation and reports
- MIT License

### Features
- Data loading and exploratory analysis
- Data cleaning and preprocessing
- Feature engineering (age groups, purchase frequency, churn risk)
- Machine learning customer segmentation
- PostgreSQL database integration
- Interactive Power BI dashboards
- Comprehensive SQL analytics queries

---

## Types of Changes

- **Added** - New features
- **Changed** - Changes to existing functionality
- **Deprecated** - Soon-to-be removed features
- **Removed** - Removed features
- **Fixed** - Bug fixes
- **Security** - Security improvements

---

[1.1.0]: https://github.com/sandeep12222300/Customer-Shopping-Behavior-Analysis/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/sandeep12222300/Customer-Shopping-Behavior-Analysis/releases/tag/v1.0.0
