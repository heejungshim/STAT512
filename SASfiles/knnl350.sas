data surgical; 
   infile 'H:\Stat512\Datasets\Ch08ta01.dat';
   input blood prog enz liver surv;
run;

options nocenter;
proc print data=surgical; 
run;

*Computing the log survival variable;
data surgical; 
   set surgical;
   lsurv=log(surv);
proc print data=surgical; 
run;
proc reg data=surgical;
   model lsurv=liver blood prog enz /ss1 ss2;
run;
* There are more options in the notes.  The b option
 gives the parameter estimates in the table;
proc reg data=surgical;
   model lsurv=blood prog enz liver/
   selection=rsquare cp aic sbc b best=3;
run;
proc corr data=surgical noprob;
	var lsurv blood prog enz liver surv;
run;
proc reg data=surgical;
   model lsurv=blood prog enz liver / selection=stepwise;
run;
quit;
 




