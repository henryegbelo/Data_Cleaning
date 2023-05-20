# Data_Cleaning
Data Cleaning in Stata

This do file performs various data cleaning and manipulation tasks in Stata. Let's break down each section:

1. **Clear log and set working directory:**
   - Clears any existing log file.
   - Sets the working directory to the specified path.

2. **Start logging:**
   - Starts logging the Stata commands and saves the log file as "1st-cleaning.txt", replacing any existing log file.

3. **Import data from Excel:**
   - Imports data from the specified Excel file and sheet into Stata, converting all variables to lowercase and treating all values as strings.

4. **Add status variable:**
   - Creates a new variable named "status" and assigns the value "4th Round Batch-2" to all observations.

5. **Check for duplicates based on index and UUID:**
   - Generates a report on duplicate values in the "_index" variable.
   - Generates a report on duplicate values in the "_uuid" variable.

6. **Remove duplicates based on UUID:**
   - Removes duplicate observations based on the "_uuid" variable, forcing deletion of duplicates.

7. **Check for duplicates based on ward, community, and household variables:**
   - Generates a report on duplicate combinations of "ward", "community", "hhno", and "headname" variables.
   - Generates a report on duplicate combinations of "lga", "ward", "community", and "hhno" variables.

8. **Clean the "consent" variable:**
   - Shows the unique values and frequencies of the "consent" variable.
   - Converts the "consent" variable from string to numeric.
   - Drops observations where the "consent" variable is equal to 0.

9. **Tag duplicate household numbers:**
   - Tags observations with duplicate combinations of "ward", "community", and "hhno" variables, creating a new variable named "duphhno".
   - Displays the frequency table of the "duphhno" variable.

10. **Export households with duplicate numbers to Excel:**
    - Sorts the data based on "lga", "ward", "community", and "hhno" variables.
    - Exports observations with duplicate household numbers to an Excel file named "Duplicates Household.xlsx", replacing any existing sheet with the same name.

11. **Drop households with duplicate numbers:**
    - Drops observations where the "duphhno" variable is greater than 0.

12. **Generate maximum household number per community:**
    - Drops the temporary variables "hhno2" and "maxhhno" if they exist.
    - Creates a new variable "hhno2" as a clone of the "hhno" variable.
    - Converts the "hhno2" variable from string to numeric.
    - Calculates the maximum value of "hhno2" for each community and stores it in the "maxhhno" variable.

13. **Check for invalid household numbers:**
    - Counts the number of observations where "hhno" is equal to "0000".
    - Sorts the data by "enumeratorname".
    - Lists the "enumeratorname", "lga", "community", "hhno", and "hhno2" variables for observations where "hhno" is equal to "0000".
    - Exports observations where "hhno" is equal to "0000" to an Excel file named "0000_HOUSEHOLD_NUMBER.xlsx", replacing any existing sheet with the same name.
    - Drops observations where "hhno" is equal to "0000".
    - Counts the number of observations where "hhno" is greater than "0600".
    - Exports observations where "hhno" is greater than
