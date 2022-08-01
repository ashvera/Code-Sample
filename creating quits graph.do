
/*
JOLTS monthly quits graph
https://download.bls.gov/pub/time.series/jt/
*/

use "$dta/jolts data 2021", clear //cleaned and loaded data

keep if annual==0

label list INDUSTRY

keep if inlist(industry,929000,0)

keep if inlist(state,"West region","Total US")

keep if ratelevel=="Rate"
keep if season == "Seasonally Adjusted"

keep industry state year month Quits

rename Quits QuitRate

gen data = "All Industries, West Region" if industry==0 & state=="West region"
replace data = "All Industries, All US" if industry==0 & state=="Total US"
replace data = "State and local government, excluding education, All US" if industry==929000 & state=="Total US"

keep if year>=2019

gen modate = ym(year, month) 
label variable modate "Year"
format modate %tmMon_CCYY

twoway 	(line QuitRate modate	if data == "All Industries, All US",color("215 48 31") lpattern(dash)) ///
		(line QuitRate modate	if data == "All Industries, West Region",color("252 141 89") lpattern("--...")) ///
		(line QuitRate modate	if data == "State and local government, excluding education, All US",color("253 204 138") lpattern(longdash_dot)), ///
		xtitle("Year") xlabel(2019.1 (6) 2021.7, labsize(small)) ///
		ytitle("Quit Rate (%)") ylab(0(0.5)3.5, labsize(small)) ///
		title("Quit Rates 2019-2021") subtitle("Monthly JOLTS") ///
		legend(label(1 "A. All Industries, All US") ///
		label(2 "B. All Industries, West Region") ///
		label(3 "C. State and local government, excluding education, All US") cols(1) size(small)) ///
		caption("{bf:Source}: {it:JOLTS}, jt.data.1.AllItems.txt", size(vsmall)) ///
		note("Quit Rate is defined by the BLS as the number of quits during the entire calendar month as a percent of total employment." "Rates are seasonally adjusted.", size(vsmall))

graph export "$out/JOLTS Monthly Quit Rates.pdf", replace
