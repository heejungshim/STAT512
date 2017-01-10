
*Read in the data using the cards statement.  The @@ allows more
   than one case per line.  The lone . represents a missing value
   and we can use this for prediction of price at that weight;
data diamonds; input weight price @@;
cards;
.17 355 .16 328 .17 350 .18 325 .25 642 .16 342 .15 322 .19 485
.21 483 .15 323 .18 462 .28 823 .16 336 .20 498 .23 595 .29 860
.12 223 .26 663 .25 750 .27 720 .18 468 .16 345 .17 352 .16 332
.17 353 .18 438 .17 318 .18 419 .17 346 .15 315 .17 350 .32 918
.32 919 .15 298 .16 339 .16 338 .23 595 .23 553 .17 345 .33 945
.25 655 .35 1086 .18 443 .25 678 .25 675 .15 287 .26 693 .15 316
.43 .
;

*Create new data set that does not include the last case (we do 
   this for plotting purposes since we don't want 0.43 included
   on the x-axis in our plots);
data diamonds1; set diamonds; if price ne .;

*Print the data set diamonds1;
proc print data=diamonds; run;

*Sort the data according to weight (if we don't, the smoothing
   curve on our plot will not work correctly);
proc sort data=diamonds1; by weight;

*Generate a scatterplot with smooth curve fitted to 
	the data.  Note that there are several preceding statements
    that can be used to title the plot and axes.;
symbol1 v=circle i=sm70;
title1 'Diamond Ring Price Study';
title2 'Scatter plot of Price vs. Weight with Smoothing Curve';
axis1 label=('Weight (Carats)');
axis2 label=(angle=90 'Price (Singapore $$)');
proc gplot data=diamonds1; 
	plot price*weight / haxis=axis1 vaxis=axis2; 
run;
*To copy plots from SAS to WORD:  (1) In SAS, select the plot and 
    choose EDIT --> COPY. (2) In WORD, put the cursor in the 
    desired location, choose EDIT --> PASTE SPECIAL and select
    "AS METAFILE".

*We can also make a plot with a regression line;
symbol1 v=circle i=rl;
title2 'Scatter plot of Price vs. Weight with Regression Line';
proc gplot data=diamonds1; 
	plot price*weight / haxis=axis1 vaxis=axis2; 
run;

*Perform regression analysis using data set 'diamonds'.  The clb option
	generates confidence interval for the slope and intercept.  
    The p option generates fitted values and standard errors. 
    The r option does some residual analysis (i.e., check 
    assumptions).  The output statement generates a new data set
	that contains the residuals and predicted/fitted values.  The
	id statement adds the variable specified to the fitted values output;
proc reg data=diamonds; model price=weight/clb p r; 
   output out=diag p=pred r=resid;
   id weight; run;

proc print data=diag; run;
*generates a residual plot to assess model assumptions;
symbol1 v=circle i=NONE;
title2 color=blue 'Residual Plot';
axis2 label=(angle=90 'Residual');
proc gplot data=diag; plot resid*weight / haxis=axis1 vaxis=axis2 vref=0; 
  where price ne .;
run;
quit;
