# HCAHPS Patient Satisfaction Scores: 2022

The CAHPS Hospital Survey (HCAHPS) is a core set of questions that can be combined with a broader, customized set of hospital-specific items for measuring patients’ perspectives on hospital care. This visualization analyzes HCAHPS patient satisfaction scores from hospitals across the United States.

### This is the process of cleaning the HCAHPS data using SQL for preparation to use in Tableau:
- Ensure provider_ccn is 6 digits, in case of leading 0 (ex: 56564 -> 056564)
- Change fiscal_year_begin_date and fiscal_year_end_date into date data type from string
- Ensure all data is u-to-date by removing hospitals with older data
