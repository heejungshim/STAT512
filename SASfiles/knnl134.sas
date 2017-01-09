*knnl134, Box-Cox transformations;
***************************************************************
*  This program performs the computations needed to generate  *
*  Table 3.9 Box-Cox Results for Plasma Levels Example        *
*  in Neter, Kutner, Nachtsheim and Wasserman, 4th ed.        *
*  See bottom part of program for an alternative approach.    *
***************************************************************;

data a1; input age plasma @@;
cards;
0 13.44 0 12.84 0 11.91 0 20.09 0 15.60
1 10.11 1 11.38 1 10.28 1 8.96 1 8.59
2 9.83 2 9.00 2 8.65 2 7.85 2 8.88
3 7.94 3 6.01 3 5.14 3 6.90 3 6.77
4 4.86 4 5.10 4 5.67 4 5.75 4 6.23
;

* First let's look at the scatterplot to see the relationship;
symbol1 v=circle i=sm50;
proc gplot;
 plot plasma*age;
run;
*Appears to be a reasonably linear relationship but the spread in
   plasma at a young age is much larger than it is at later ages. The 
   observations (at young age) also seem a little skewed (i.e., nonnormal).
   We'll run Box-Cox to see what transformation we should use on Y; 

*The first part of the program gets the geometric mean (see 3.36a).  
     The second part creates a data set that contains the standardized
     observations for each value of lambda;
data a2; set a1; lplasma=log(plasma);
proc univariate data=a2 noprint; var lplasma; output out=a3 mean=meanl;
data a4; set a2; if _n_ eq 1 then set a3;
 k2=exp(meanl);
 do l = -1.0 to 1.0 by 0.1;  
      k1=1/(l*k2**(l-1));
      yl=k1*(plasma**l -1);
	  if abs(l) < 1E-8 then yl=k2*log(plasma); /* SAS has problem near zero */
      output;
  end;
  keep age yl l;

*Now we sort by lambda and perform regression on each transformed 
  	data set, saving the sse;
proc sort data=a4 out=a4; by l;proc print; run;
proc reg data=a4 noprint outest=a5; model yl=age; by l;
data a5; set a5; n=25; p=2; sse=(n-p)*(_rmse_)**2;
proc print data=a5; var l sse;
symbol1 v=none i=join;
proc gplot data=a5; plot sse*l/frame;
run;
**************************************************************
*  Alternative approach using R**2 as criterion.             *
**************************************************************;
data a2; set a1;
   do l = -1.0 to -.1 by .1;
	  yl=(plasma**l -1)/l; 
      output;
   end;
   l=0; yl=log(plasma); output;
   do l = .1 to 1 by .1; 
      yl=(plasma**l -1)/l; 
      output;
   end;
proc sort data=a2 out=a2; by l;
proc reg data=a2 noprint outest=a3; 
   model yl=age/selection=rsquare; by l;
proc print data=a3; var l _rsq_;
proc gplot data=a3; plot _rsq_*l/frame;
run;

*Using -.5 as the transformation, we now plot y^-.5 vs x and 
   y^-.5 vs x^-.5. to see which is more linear.  Since the youngest
   age is age=0, we add .5 in order to take the square root;
data a1;
 set a1;
 tplasma = plasma**(-.5);
 tage = (age+.5)**(-.5);

symbol1 v=circle i=sm50; 
proc gplot;
 plot tplasma*age;

proc sort; by tage;
proc gplot;
 plot tplasma*tage;
run;
quit;
