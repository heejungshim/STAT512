*boxcox.sas, Box-Cox transformations;
***************************************************************
*  This program performs the Box-Cox transformation on        *
*  Table 3.9 Plasma Levels Example                            *
*  in Neter, Kutner, Nachtsheim and Wasserman, 4th ed.        *
***************************************************************;

data orig; input age plasma @@;
cards;
0 13.44 0 12.84 0 11.91 0 20.09 0 15.60
1 10.11 1 11.38 1 10.28 1 8.96 1 8.59
2 9.83 2 9.00 2 8.65 2 7.85 2 8.88
3 7.94 3 6.01 3 5.14 3 6.90 3 6.77
4 4.86 4 5.10 4 5.67 4 5.75 4 6.23
;
* First let's look at the scatterplot to see the relationship;
title1 'Original Variables';
proc print data=orig;
symbol1 v=circle i=rl;
proc gplot data=orig;
 plot plasma*age;
proc reg data=orig;
	model plasma=age;
	output out = notrans r = resid;
run;
symbol1 i=sm70;
proc gplot data = notrans;
	plot resid*age / vref = 0;
proc univariate data=notrans; 
	var resid; qqplot/normal (L=1 mu = est sigma=est);
* The residuals do not appear to have constant variance and the 
* relationship is not quite linear.  Use the Box-Cox procedure to
* suggest a possible transformation of the Y variable;
proc transreg data = orig;
	model boxcox(plasma)=identity(age);
run;
* Box-Cox suggests logY or 1/sqrt(Y).  Let's do both of these.;
title1 'Transformed Variables';
data trans; set orig; 
	logplasma = log(plasma);
	rsplasma = plasma**(-0.5);
proc print data = trans; 
run;
title1 'Log Transformation';
proc reg data = trans;
	model logplasma = age;
	output out = logtrans r = logresid;
run;
symbol1 i=rl;
proc gplot data = logtrans;
	plot logplasma * age;
run;
symbol1 i=sm70;
proc gplot data = logtrans;
	plot logresid * age / vref = 0;
proc univariate data=logtrans; 
	var logresid; qqplot/normal (L=1 mu = est sigma = est);
run;
title1 'Reciprocal Square Root Transformation';
proc reg data = trans;
	model rsplasma = age;
	output out = rstrans r = rsresid;
run;
symbol1 i=rl;
proc gplot data = rstrans;
	plot rsplasma * age;
	run;
symbol1 i=sm70;
proc gplot data = rstrans;
	plot rsresid * age / vref = 0;
proc univariate data=rstrans; 
	var rsresid; qqplot/normal (L=1 mu = est sigma = est);
run;
quit;
