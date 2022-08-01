clear 
set more off

/*
Reshape & Loop
Display blood pressure before and after & demographic details for patients 10, 12, 72 and 81
*/
sysuse bplong.dta, clear
codebook 

reshape wide bp, i(patient sex agegrp) j(when) 
label variable bp1 "Blood Pressure (Before)"
label variable bp2 "Blood Pressure (After)"

* list frequency of observations within each category
preserve
contract sex agegrp, zero freq(freq) percent(percent)	
list, clean
restore

foreach code in 10 12 72 81 {
	list if patient == `code'
}

table 
