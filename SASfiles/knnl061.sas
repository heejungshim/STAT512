*KNNL061 Working Hotelling bounds for regression;
*Conversion of W bound to equivalent t with a different alpha;

*Suppose you want a 90% confidence band.  What alpha level would you 
	use when forming an individual confidence interval?;

data a1; n=25; alpha=.10; dfn=2; dfd=n-2; w2=2*finv(1-alpha,dfn,dfd);
   w=sqrt(w2);  alphat=2*(1-probt(w,dfd));
   tstar=tinv(1-alphat/2, dfd); output;
proc print data=a1;run;

*Turns out we want to form 96.7% confidence intervals.  The 
	following generates a scatterplot with a set of 97% 
   	confidence intervals (i=rlclm97) which is approximately
        a 90% confidence bound;
data a2; 
   infile 'H:\Stat512\Datasets\Ch01ta01.dat';
   input size hours;

symbol1 v=circle i=rlclm97;
proc gplot data=a2; 
   plot hours*size;
run;
quit;
