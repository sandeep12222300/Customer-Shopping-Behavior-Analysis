# Jupyter Notebooks

## Customer_Behavior_Analysis.ipynb

This notebook contains the complete analysis workflow for customer shopping behavior.

### What's Inside

1. **Data Loading** - Import and initial exploration
2. **Exploratory Data Analysis (EDA)** - Statistical analysis and visualization
3. **Data Cleaning** - Handle missing values and standardize data
4. **Feature Engineering** - Create derived features for analysis
5. **Machine Learning** - K-Means clustering for customer segmentation
6. **Model Evaluation** - Assess clustering quality
7. **Database Integration** - Export results to PostgreSQL

### Running the Notebook

```bash
# Activate virtual environment
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Launch Jupyter
jupyter notebook

# Open Customer_Behavior_Analysis.ipynb
```

### ⚠️ Important Security Notes

**Database Connection (Cell 37)**

The notebook contains a database connection section with placeholder credentials:

```python
username = "postgres"
password = "postgres"
```

**BEFORE running the database integration section:**

1. **Option 1: Use Environment Variables (Recommended)**
   
   Update cell 37 to use the config module:
   ```python
   from config.db_config import get_db_connection_string
   engine = create_engine(get_db_connection_string())
   ```

2. **Option 2: Update Credentials Directly (Less Secure)**
   
   Change the values in cell 37 to your actual credentials:
   ```python
   username = "your_username"
   password = "your_actual_password"
   ```
   
   **Important:** 
   - Clear outputs before committing: Cell → All Output → Clear
   - Never commit with real credentials visible

3. **Option 3: Skip Database Section**
   
   You can run the entire analysis without the database integration. Simply:
   - Stop before cell 37 (Database Integration section)
   - Use the exported CSV files instead

### Data Files

The notebook expects data files in the `../data/` directory:
- `customer_shopping_behavior.csv` - Raw data (input)
- `customer_behavior_with_ml_segments.csv` - Processed data (output)

### Output Files

The notebook generates:
- `customer_behavior_with_ml_segments.csv` - Enhanced dataset with ML features

### Notebook Best Practices

1. **Run in Order:** Execute cells sequentially from top to bottom
2. **Restart Kernel:** If you encounter errors, try Kernel → Restart & Run All
3. **Save Checkpoints:** Regularly save your work (Ctrl+S or Cmd+S)
4. **Clear Outputs:** Before committing, clear sensitive outputs
5. **Virtual Environment:** Always run within the project's virtual environment

### Troubleshooting

**Issue:** Module not found error
```
Solution: Ensure virtual environment is activated and dependencies are installed
```

**Issue:** File not found error
```
Solution: Check that you're running from the notebooks/ directory
         or update the file path in cell 2
```

**Issue:** Database connection error
```
Solution: Verify PostgreSQL is running and credentials are correct
         See docs/DATABASE.md for detailed setup
```

**Issue:** Memory error with large datasets
```
Solution: Process data in chunks or increase available RAM
```

### Customization

Feel free to modify the notebook for your needs:
- Adjust K-means cluster count (default: 4)
- Change age group ranges
- Modify churn risk thresholds
- Add new features
- Create additional visualizations

### Resources

- [Jupyter Documentation](https://jupyter-notebook.readthedocs.io/)
- [Pandas Documentation](https://pandas.pydata.org/docs/)
- [Scikit-learn Documentation](https://scikit-learn.org/stable/)
- [Project Documentation](../docs/)

### Need Help?

- Check [docs/INSTALLATION.md](../docs/INSTALLATION.md) for setup issues
- Review [docs/ANALYSIS_GUIDE.md](../docs/ANALYSIS_GUIDE.md) for methodology
- Open an issue on GitHub for questions or bugs

Happy analyzing! 📊
