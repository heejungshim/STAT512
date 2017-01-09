*KNNL050 Power for slope parameter in simple regression;

*need to enter information necessary to compute noncentrality
 	parameter, delta.  The tinv function computes the 
	t-value such that the area to the left of this number
	in a specified value (here  1-alpha/2).  The probt
	function computes the area to the left for a specifed 
	t-value (here, tstar);
data a1;
   n=25; sig2=2500; ssx=19800; alpha=.05;
   sig2b1=sig2/ssx; df=n-2;
   beta1=1.5;
   delta=abs(beta1)/sqrt(sig2b1);
   tstar=tinv(1-alpha/2,df);
   power=1-probt(tstar,df,delta)+probt(-tstar,df,delta);
   output;

proc print data=a1;run;

*this computes the power for numerous slope values using a 
	loop process.  After the power is calculated for 
	each beta1 value, the results are written to the 
	data set using the output statement;
data a2;
   n=25; sig2=2500; ssx=19800; alpha=.05;
   sig2b1=sig2/ssx; df=n-2;
   do beta1=-2.0 to 2.0 by .05;
      delta=abs(beta1)/sqrt(sig2b1);
      tstar=tinv(1-alpha/2,df);
      power=1-probt(tstar,df,delta)+probt(-tstar,df,delta);
      output;
   end;

proc print data=a2;run;

*This generates a power curve based on the output in data set a2;
title1 'Power for the slope in simple linear regression';
symbol1 v=none i=join;
proc gplot data=a2; plot power*beta1;run;
quit;
