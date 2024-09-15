/*  Desc: This dofile cleans the raw PatentsView patent data
    See Makefile for list if inputs and outputs */

clear all
capture set more off


* Table: patent

// Read data
import delimited ../input/patent.tsv, delim(tab) varnames(1) clear
drop abstract title filename

// Check that patent id and number are identical
count if id != number
drop if id != number
drop number
rename id patent_id

// Check that country in which patent was granted is always US
assert country == "US"
drop country

// Get grant date
gen date2 = date(date, "YMD")
format date2 %td
gen year_g = year(date2)
gen month_g = month(date2)
gen day_g = day(date2)
drop date date2
label var year_g "patent grant year"

// Trim if needed
foreach v of varlist patent_id type kind withdrawn {
    replace `v' = strtrim(`v')
}

// Set NULL to missing in strings
foreach v of varlist type kind withdrawn {
    replace `v' = "" if `v' == "NULL"
}

// Transform withdrawn into binary and set NULL to missing
destring withdrawn, replace

// Drop duplicates (if any)
contract _all
drop _freq

// Save
order patent_id type kind *_g
export delimited using ../output/patent.csv, delimiter(tab) replace