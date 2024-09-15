/*  This dofile merges patents in PATSTAT and PatentsView and produces a
    concordance table between PatentsView and Patstat.
    Merge on publication number: publn_nr (Patstat), patent_id (PatentsView) 
    
    See Makefile for list of inputs and outputs */

clear all
capture set more off


* -----------------------------------------------------------------------------
* Merge Patstat and Patentsview using patent publication number
* -----------------------------------------------------------------------------
// Get USPTO publication number for all appln_id in Patstat
use ../input/publn_info, clear
keep if strtrim(publn_auth) == "US"
tempfile tls211
save "`tls211'", replace

// Merge Patstat and PatentsView (on publication number)
import delimited ../input/patent.csv, delimiter(tab) varnames(1) clear
rename patent_id publn_nr
merge 1:m publn_nr using "`tls211'"
tempfile match
keep if _merge == 3
contract publn_nr appln_id
drop _freq
rename publn_nr patent_id
// Drop artificial applications
drop if appln_id >= 930000001
save "`match'", replace
// Save Patstat-PatentsView concordance
export delimited using ../output/patstat_patentsview_conc.csv, ///
    delimiter(tab) replace
// Export codebook    
label var patent_id "patent_id from PatentsView"
label var appln_id "appln_id from Patstat tls201, (table tls201 key)"
describe, replace clear
list
export delimited using ../output/patstat_patentsview_conc_codebook.csv, ///
    delimiter(tab) replace

// Find patent family of each merged patent publication number
use "`match'", clear
merge m:1 appln_id using ../input/appln_info, keep(match master) ///
    keepusing(granted appln_auth appln_kind)
assert appln_auth == "US"    
drop _merge
gen tmp = granted == "Y"
drop granted
rename tmp granted
joinby appln_id using ../input/family_info, unmatched(master)
tempfile patstat_patentsview
keep patent_id docdb_family_id granted fam_earliest_appln_year ///
    fam_earliest_publn_year
save "`patstat_patentsview'", replace
contract docdb_family_id patent_id granted
drop _freq
// Save merged publication numbers and corresponding patent family
sort patent_id docdb_family_id
export delimit using ../output/docdb_uspto_patent_id.csv, delimiter(tab) replace
// Export codebook    
label var patent_id "patent_id from PatentsView"
label var docdb_family_id "docdb_family_id from Patstat"
label var granted "USPTO granted application"
describe, replace clear
list
export delimited using ../output/docdb_uspto_patent_id_codebook.csv, ///
    delimiter(tab) replace


* -----------------------------------------------------------------------------
* Check match quality
* -----------------------------------------------------------------------------
import delimited ../input/patent.csv, delimiter(tab) varnames(1) clear
keep patent_id year_g
merge 1:1 patent_id using "`patstat_patentsview'", keep(match using)
count if fam_earliest_appln_year > year_g & fam_earliest_appln_year != 9999