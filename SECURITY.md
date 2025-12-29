# Security Policy

## Reporting Security Vulnerabilities

If you discover a security vulnerability in this project, please report it by:

1. **Do NOT** create a public GitHub issue
2. Email the maintainer directly or use GitHub's private vulnerability reporting
3. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

We will respond to security reports within 48 hours and work to address valid issues promptly.

---

## Security Best Practices

### 1. Credential Management

**Never commit sensitive information:**
- Database passwords
- API keys
- Access tokens
- Private keys

**Use environment variables:**
```bash
# Create .env file (already in .gitignore)
DB_PASSWORD=your_secure_password
```

**Use the provided configuration module:**
```python
from config.db_config import get_db_connection_string
# This reads from environment variables
```

---

### 2. Database Security

**Strong passwords:**
- Minimum 12 characters
- Mix of uppercase, lowercase, numbers, and symbols
- No dictionary words or personal information

**Principle of least privilege:**
```sql
-- Create users with only necessary permissions
CREATE USER analytics_read WITH PASSWORD 'strong_password';
GRANT SELECT ON customer TO analytics_read;
```

**Enable SSL connections in production:**
```python
engine = create_engine(
    connection_string,
    connect_args={'sslmode': 'require'}
)
```

---

### 3. Data Privacy

**Anonymize sensitive data:**
- Remove or hash personally identifiable information (PII)
- Use aggregate data when possible
- Follow GDPR, CCPA, and other data protection regulations

**Sample data for testing:**
- Use synthetic data for development
- Never use production data with real customer information

---

### 4. Dependency Security

**Keep dependencies updated:**
```bash
# Check for security vulnerabilities
pip install safety
safety check

# Update packages
pip install --upgrade -r requirements.txt
```

**Review dependencies:**
- Only use well-maintained packages
- Check for known vulnerabilities
- Audit new dependencies before adding

---

### 5. SQL Injection Prevention

**Always use parameterized queries:**

❌ **Vulnerable:**
```python
query = f"SELECT * FROM customer WHERE id = {user_input}"
```

✅ **Safe:**
```python
query = "SELECT * FROM customer WHERE id = %s"
cursor.execute(query, (user_input,))
```

**Use ORM features:**
```python
# SQLAlchemy automatically handles parameterization
df = pd.read_sql_query(
    "SELECT * FROM customer WHERE segment = :segment",
    engine,
    params={'segment': user_segment}
)
```

---

### 6. Code Security

**Input validation:**
```python
def validate_age(age):
    if not isinstance(age, int) or age < 0 or age > 120:
        raise ValueError("Invalid age")
    return age
```

**Error handling:**
```python
try:
    engine = create_engine(connection_string)
except Exception as e:
    # Don't expose connection details in error messages
    logger.error("Database connection failed")
    raise
```

---

### 7. Jupyter Notebook Security

**Clear sensitive outputs:**
- Clear all cell outputs before committing
- Use `nbstripout` to automatically remove outputs

**Don't store credentials in notebooks:**
```python
# Bad
password = "mypassword123"

# Good
import os
password = os.getenv('DB_PASSWORD')
```

---

### 8. Access Control

**File permissions:**
```bash
# Restrict .env file access
chmod 600 .env

# Ensure scripts are not world-writable
chmod 644 *.py
```

**Database access:**
- Use different credentials for development and production
- Rotate passwords regularly
- Audit access logs

---

## Security Checklist

Before deploying or sharing:

- [ ] No hardcoded credentials in code
- [ ] `.env` file in `.gitignore`
- [ ] All dependencies are up to date
- [ ] SQL queries use parameterization
- [ ] Error messages don't expose sensitive information
- [ ] File permissions are appropriate
- [ ] Sensitive outputs cleared from notebooks
- [ ] Database connections use SSL (production)
- [ ] Strong passwords enforced
- [ ] Regular backups configured

---

## Supported Versions

We provide security updates for:

| Version | Supported |
|---------|-----------|
| 1.0.x   | ✅ Yes    |
| < 1.0   | ❌ No     |

---

## Known Security Considerations

### Current Implementation

1. **Database Credentials**: This project uses environment variables for credential management. Ensure `.env` is never committed.

2. **Sample Data**: The included dataset is for demonstration purposes. Replace with your own data and implement appropriate access controls.

3. **Local Development**: Default configuration is for local development. Additional security measures needed for production deployment.

---

## Security Resources

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Python Security Best Practices](https://python.readthedocs.io/en/stable/library/security_warnings.html)
- [PostgreSQL Security](https://www.postgresql.org/docs/current/security.html)
- [GitHub Security Best Practices](https://docs.github.com/en/code-security)

---

## Updates

This security policy is reviewed and updated regularly. Last updated: 2024

For questions about security, please contact the maintainer.
