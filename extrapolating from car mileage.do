clear 
set more off

/*
Econometric Analysis & Visualization
Assume fictional new car "RoadRage" with weight of 3500 lbs and actual mileage of 14 mpg. We want to see if this is an appropriately standard mileage for this car, by visualizing actual vs extrapolation derived from trend among 74 other cars on the market.
*/
sysuse autornd.dta

reg mpg weight
local r2: display %5.4f e(r2)
local expected = _b[_cons] + _b[weight]*3500
local fmtexp : display %7.0fc `expected' 

graph twoway (lfitci mpg weight) ///
	(scatter mpg weight, ///
	ylab(,format(%9.0gc) labsize(small)) ytitle("Mileage (mpg)") ///
	xlab(,format(%9.0gc)) xtitle("Weight (lbs)") ///
	title("Mileage for RoadRage") color(maroon)) ///
	(scatteri 14  3500  "14", mcolor(green) msymbol(T) mlabcolor(green) mlabposition(6)) ///
	(scatteri `expected' 3500 "`fmtexp'", color(green) msymbol(S) mlabcolor(green) mlabposition(6)), note(R-squared=`r2') ///
	legend(order(3 4 5) label(3 "Comparison Group") label(4 "Actual Mileage") label(5 "Extrapolated Mileage") pos(6) col(3))

	//Extrapolated: 19 mpg
	//Actual: 14 mpg (not within 95% CI) --> we can determine that RoadRage is an inefficient car by industry standards

	