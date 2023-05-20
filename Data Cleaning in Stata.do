// Clear log and set working directory
capture log close
cd "C:\Users\Henry\OneDrive\Documents\CBT SCALE_UP\ROUND 4\1ST BATCH"

// Start logging
log using "1st-cleaning", text replace

// Import data from Excel
import excel "CRS_Standardized_PVHH_Checklist_BATCH4_-_all_versions_-_False_-_2022-08-14-15-07-56.xlsx", sheet("CRS Standardized PVHH Checkl...") firstrow case(lower) allstring clear

// Add status variable
gen status = "4th Round Batch-2"

// Check for duplicates based on index and UUID
duplicates report _index
duplicates report _uuid

// Remove duplicates based on UUID
duplicates drop _uuid, force

// Check for duplicates based on ward, community, and household variables
duplicates report ward community hhno headname
duplicates report lga ward community hhno

// Clean the "consent" variable
ta consent
destring consent, replace
drop if consent == 0

// Tag duplicate household numbers
duplicates tag ward community hhno, gen(duphhno)
tab duphhno

// Export households with duplicate numbers to Excel
sort lga ward community hhno
export excel using "Duplicates Household.xlsx" if duphhno > 0, sheetreplace firstrow(variables)

// Drop households with duplicate numbers
drop if duphhno > 0

// Generate maximum household number per community
capture: drop hhno2 maxhhno
clonevar hhno2 = hhno
destring hhno2, replace
bysort community: egen maxhhno = max(hhno2)

// Check for invalid household numbers
count if hhno == "0000"
sort enumeratorname
li enumeratorname lga community hhno hhno2 if hhno == "0000"
export excel using "0000_HOUSEHOLD_NUMBER.xlsx" if hhno == "0000", sheetreplace firstrow(variables)
drop if hhno == "0000"
count if hhno > "0600"
export excel using "0700_HOUSEHOLD_NUMBER.xlsx" if hhno > "0700", sheetreplace firstrow(variables)
list enumeratorname lga community hhno hhno2 if hhno > "0600" | hhno == "0000"
drop if hhno > "0600"

// Export duplicates households to Excel
sort ward community hhno
cap: export excel using "Duplicates Household Roster.xlsx" if duphhno>0, sheetreplace firstrow(variables)
rename _index hhid
duplicates drop hhid, force

// Save the data as Stata file
save "PVHH_R4_2ND BATCH.dta", replace


// Import household roster data from Excel
import excel "CRS_Standardized_PVHH_Checklist_BATCH4_-_all_versions_-_False_-_2022-08-14-15-07-56.xlsx", sheet("HouseholdRoster") firstrow case(lower) allstring clear

// Save the household roster data as Stata file
save "BATCH4-ROSTER.dta", replace
rename _parent_index hhid
duplicates drop hhid, force

// Merge household roster data with the cleaned dataset
merge 1:1 hhid using "PVHH_R4_2ND BATCH.dta"

sort lga ward community hhno relationship
// Zonal Code for SOUTH-SOUTH-SOUTH
gen zonecode = "SS"

// State Code for CROSS RIVER
gen statecode = "CR"

replace lga = upper(lga)
// LGA Code
gen lgacode = ""
replace lgacode = "ABI" if lga == "ABI" 
replace lgacode = "AKA" if lga == "AKAMKPA" 
replace lgacode = "AKP" if lga == "AKPABUYO" 
replace lgacode = "BAK" if lga == "BAKASSI" 
replace lgacode = "BEK" if lga == "BEKWARRA" 
replace lgacode = "BIA" if lga == "BIASE" 
replace lgacode = "BOK" if lga == "BOKI" 
replace lgacode = "CMG" if lga == "CALABAR-MUNICIPALITY" 
replace lgacode = "CSG" if lga == "CALABAR-SOUTH" 
replace lgacode = "ETU" if lga == "ETUNG"
replace lgacode = "IKM" if lga == "IKOM" 
replace lgacode = "OBL" if lga == "OBANLIKU" 
replace lgacode = "OBR" if lga == "OBUBRA"
replace lgacode = "OBU" if lga == "OBUDU" 
replace lgacode = "ODU" if lga == "ODUKPANI"
replace lgacode = "OGJ" if lga == "OGOJA"	
replace lgacode = "YAK" if lga == "YAKURR"
replace lgacode = "YAL" if lga == "YALA"

// convert urbanrural to string
tostring urbanrural, replace

// convert hhno to string
tostring hhno, replace
capture drop temp
gen temp = length(hhno)
replace hhno = "000" + hhno if temp == 1
replace hhno = "00" + hhno if temp == 2
replace hhno = "0" + hhno if temp == 3

// Household reference Number: (zonacode/statecode/lgacode/community/urbanrural/hhno)
generate hh_ref = zonecode + "/" + statecode + "/" + lgacode + "/" + community + "/" + urbanrural + "/" + hhno

// member number: mno
by hh_ref (relationship), sort: generate mno = _n

// convert mno to string
tostring mno, replace
capture drop temp
gen temp = length(mno)
replace mno = "0" + mno if temp == 1

// Household member reference Number: (zonacode/statecode/lgacode/community/urbanrural/hhno/mno)
generate member_ref = zonecode + "/" + statecode + "/" + lgacode + "/" + community + "/" + urbanrural + "/" + hhno + "/" + mno

// Remove duplicates based on household and member reference numbers
duplicates drop hh_ref member_ref, force

// Clean variables
tostring hh_ref member_ref, replace
replace hhno = subinstr(hhno, " ", "", .)
replace hhno = subinstr(hhno, "NA", "", .)
replace hhno = subinstr(hhno, "N/A", "", .)
replace hhno = subinstr(hhno, "0", "", .)
replace headname = subinstr(headname, "NA", "", .)
replace headname = subinstr(headname, "N/A", "", .)
replace headname = subinstr(headname, "NONE", "", .)

// Save the data as Stata file
save "PVHH_clean_var.dta", replace

// End logging
log close


/*
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