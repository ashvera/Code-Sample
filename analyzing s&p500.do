clear 
set more off

/*
Analyzing S&P500, generating graphs
*/
sysuse sp500.dta, clear

*  regression with up to 3 lagged variables for close
tsset date
gen lag1 = L1.close //problem: there are 56 missing values generated for holidays/weekends, so we want to work around this

drop lag1
gen byte notmiss = !missing(close)
gen seqdate = cond(notmiss, sum(notmiss),.)
tsset seqdate

gen lag1 = L1.close 
gen lag2 = L2.close
gen lag3 = L3.close
reg close lag1 lag2 lag3 //shows previous day's close value is best indicator of future value

* visualize change in close values vs actual close values
tsset date
tsline change, yline(0)	//difference in close values	 
tsline close, yline(0) 	//actual close values 

* generate averages by month  
gen month = month(date)
gen year = year(date)
collapse avgclose = close, by(month year)
