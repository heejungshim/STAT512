*KNNL110, diagnostics for simple linear regression;

options nocenter;
goptions colors=(none);
title1 'Toluca Diagnostics';
data toluca;
   infile 'H:\Stat512\Datasets\CH01TA01.DAT';
   input lotsize workhrs;

*output statement generates new data set containing the 
	residuals (r=) in a variable called resid;
proc reg data=toluca;
   model workhrs=lotsize;
   output out=diag r=resid; 

*The normal option of proc univariate provides tests of 
	normality. The normal and kernel draw smooth 
	curves of the distribution.  The L= option species
	the line type to use;
proc univariate data=diag plot normal; 
   var resid;
   histogram resid / normal kernel(L=2);
   qqplot resid / normal (L=1 mu=est sigma=est); 
run;

*to construct your own normal quantile plot and add a 
	smoothed curve to it to see if linear.  Proc
	rank ranks the data from smallest to largest.  
	Proc sort sorts the data based on zresid;
proc rank data=diag out=a3 normal=blom;
  var resid;
  ranks zresid;

proc sort data=a3; by zresid;

symbol1 v=circle i=sm60;
proc gplot data=a3; 
	plot resid*zresid;
run;


