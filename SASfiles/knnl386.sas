*KNNL386, Regression diagnostics;
title1 'Insurance';
options nocenter;
data insurance; 
	infile 'H:\Stat512\Datasets\Ch09ta01.dat';
	input income risk amount;
run;
proc print data=insurance;
proc reg data=insurance; 
  	model amount=income risk/r influence;
run;
proc reg data=insurance; 
  	model amount=income risk/tol vif;
run;
*Contains the new options partial influence and tol (tolerance).  
   The partial command creates line printer plots in the output
   window.  These are difficult to read and not that pretty.

   Also included is a plot statement within proc reg.  This is another way
   to generate residual plots.  Here the residuals (called r.) are plotted 
   against each explanatory variable;
title1 'Automatic residual plots';
proc reg data=insurance; 
  	model amount=income risk/r partial;
	id income risk; 
  	plot r.*(income risk);
run;

title1 'Partial residual plot';
title2 'for risk';
symbol1 v=circle i=rl;
axis1 label=('Risk Aversion Score');
axis2 label=(angle=90 'Amount of Insurance');
proc reg data=insurance; 
	model amount risk = income;
	output out=partialrisk r=resamt resrisk;
proc gplot data=partialrisk;
   plot resamt*resrisk / haxis=axis1 vaxis=axis2 vref = 0;
run;
axis3 label=('Income'); 
title2 'for income';
proc reg data=insurance; 
	model amount income = risk;
   	output out=partialincome r=resamt resinc;
proc gplot data=partialincome;
   plot resamt*resinc / haxis=axis3 vaxis=axis2 vref = 0;
run;

proc reg data=insurance; 
	model amount= risk income;
   	output out=diag r=resins;
run;
symbol1 v=circle i=sm70;
title1 'Plot of residuals versus risk';
proc sort data=diag; by risk;
proc gplot data=diag;
   plot resins*risk / vref = 0;
run;

title1 'Plot of residuals versus income';
proc sort data=diag; by income;
proc gplot data=diag;
   plot resins*income / vref = 0;
run;
data quad;	
	set insurance;
	sinc = income;
proc standard data=quad out=quad mean=0;
	var sinc;
data quad;
	set quad;
	incomesq = sinc*sinc;
title1 'Residuals for quadratic model';
proc reg data=quad;
	model amount = income risk incomesq / r vif;
	plot r.*(income risk incomesq);
run;
proc corr data=quad;
run;
data bonf;
	tb = tinv(0.998611, 14); tn = tinv(0.975, 14); output;
proc print data=bonf;
run;
/*
The following code helps explain the partial regression
residual plot with the intercept;
data b1; set insurance; x0=1;
proc reg data=b1; model x0=income risk/r noint;
output out=c1 r=intresid;
run;

proc reg data=b1; model amount=income risk/r noint;
output out=c2 r=insresid;
run;

symbol v=circle;
data c3; merge c1 c2;
proc gplot data=c3; plot insresid*intresid/frame;
run;
*/
quit;
