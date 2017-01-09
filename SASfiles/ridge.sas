options nocenter;
/* Read in the data */
data bodyfat;
	infile 'H:\System\Desktop\CH07TA01.dat';
	input skinfold thigh midarm fat;
run;

proc print data = bodyfat;
run;

/* Original Regression */
proc reg data = bodyfat;
	model fat = skinfold thigh midarm;
run;

/* Variables are highly correlated */
proc corr data = bodyfat noprob;
run;

/* Plot the ridge trace */
title1 'Ridge Trace';
title2 'Body Fat Example';
symbol1 v = S i = none c = black;
symbol2 v = T i = none c = black;
proc reg data = bodyfat outvif
	outest = bfout ridge = 0 to .03 by 0.002;
	model fat = skinfold thigh midarm / noprint;
	plot / ridgeplot nomodel nostat;
run;

title2 'Variance Inflation Factors';
proc gplot data = bfout;
	plot (skinfold thigh midarm)* _RIDGE_ / overlay;
	where _TYPE_ = 'RIDGEVIF';
run;


proc print data = bfout;
	var _RIDGE_ skinfold thigh midarm;
	where _TYPE_ = 'RIDGEVIF';

title2 'Parameter Estimates';
proc print data = bfout;
	var _RIDGE_ _RMSE_ Intercept skinfold thigh midarm;
	where _TYPE_ = 'RIDGE';
run;
