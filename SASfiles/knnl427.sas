data pressure;
  infile 'H:\Stat512\Datasets\Ch10ta01.dat';
  input age diast;
proc print data=pressure;
run;

*Weighted regression analysis.  Used to adjust for nonconstant variance.  This is very obvious in the
   scatterplot.  First fit the model as usual and save the residuals; 
title1 'Blood Pressure';
symbol1 v=circle i=sm70;
proc sort data=pressure; 
	by age;
proc gplot data=pressure;
  plot diast*age;
run;
proc reg data=pressure;
  model diast=age / clb;
  output out=diag r=resid;
run;

*Compute the absolute and squared residuals to 
  find pattern with age;
data diag; 
  set diag;
  absr=abs(resid);
  sqrr=resid*resid;

proc gplot data=diag;
   plot (resid absr sqrr)*age;
run;
*From scatterplot, model absolute residual as a linear 
   function of age.  Fit model and predict the standard
   deviation for each observation;
proc reg data=diag; 
   model absr=age;
   output out=findweights p=shat;

*Compute weights;
data findweights; 
   set findweights;
   wt=1/(shat*shat);

*Run weighted analysis using weight statement;
proc reg data=findweights;
   model diast=age / clb p;
   weight wt; 
   output out = weighted p = predict;
run;


symbol1 v = none i = join l = 1 c = black;
symbol2 v = circle i = rl l = 3 c = red;
proc gplot data=weighted;
	plot (predict diast) * age / overlay;
run;
quit;