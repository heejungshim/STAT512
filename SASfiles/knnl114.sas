*nknw110, Tests involving residuals;

data a1;
   infile 'c:\Temp\512SAS\CH01TA01.DAT';
   input lotsize workhrs;
   seq=_n_;


*For the Durban-Watson test, use the dw option on the
   model statement then use Table B.7 in the text.  Be 
   sure that the observations are sorted in run order;
proc reg data=a1; 
  model workhrs=lotsize /dw;
  output out=a2 p=pred r=resid;

*For the modifed Levene's test, we need to break the 
  observations into two groups based on their X value.
  We use the Proc univariate and the plot option to find
  a good breaking point;
proc univariate plot;
  var lotsize;
run;

*Decided to use X <= 70 to divide up the observations.  The first
  step involves creating this group variable in the data set;
data a2; set a2;
  grp=2; if lotsize <= 70 then grp=1;

*Now sort the data by group and use proc univariate to compute
  the medians of each group.  The noprint option suppresses output;
proc sort; by grp;
proc univariate data=a2 noprint;
 var resid;
 by grp;
 output out=a2m median=med;

*Now merge the medians with the original data set and then
  compute the absolute differences;
data a3; merge a2 a2m; by grp;
data a3; set a3;
 diff=abs(resid-med);

*Now do the t-test;
proc ttest;
 class grp;
 var diff;
run;

*The Breusch-Pagan test involes fitting a model using the 
  squared residuals of the original model as the response 
  variable and getting the predicted values.  Proc univariate
  is then used to get certain summary statistics; 

*This adds the variable resid2 to data set a2;
data a2; set a2; resid2=resid*resid;

*Noprint supresses output;
proc reg data=a2 noprint; 
  model resid2=lotsize;
  output out=a3 p=pstar;

*This computes the necessary sum of squares;
proc univariate data=a3 noprint; 
  var pstar resid;
  output out=a4 css=ssrstar sse n=nstar n;

*This adds chisq and p to the data set a4;
data a4; set a4; chisq=(ssrstar/2)/((sse/n)*(sse/n));
  p=1-probchi(chisq,1);
  proc print data=a4;
run;


