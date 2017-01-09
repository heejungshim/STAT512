*KNNL706.sas, one way anova using data in Table 16.1;
options nocenter;

data cereal; 
	infile 'H:\Stat512\Datasets\CH16TA01.DAT';
   input cases pkgdes store;

*output here includes mean for each design
   and mean of all 19 cases.  This overall mean
   will not be the same as the average of the 
   treatment means because the n_i's are not equal;
proc means data=cereal printalltypes; 
   class pkgdes; 
   var cases;
   output out=cerealmeans mean=mclass; 
run;

proc print data=cerealmeans; 
run;

*this output will give the mean of the four group means.
   The where statement throws out the first row;
proc means data=cerealmeans mean; 
   where _TYPE_ eq 1; 
   var mclass;
run;

*this is an alternative way to generate the dummy
   variables.  The if/then statement was used in the HW;
data cereal; set cereal;
   x1=(pkgdes eq 1)-(pkgdes eq 4);
   x2=(pkgdes eq 2)-(pkgdes eq 4);
   x3=(pkgdes eq 3)-(pkgdes eq 4);
proc print data=cereal; run;

*run the regression;
proc reg data=cereal; 
   model cases=x1 x2 x3;
run;

*run the ANOVA;
proc glm data=cereal; 
   class pkgdes;
   model cases=pkgdes;
run;


*Reweighting to keep column sums equal to 0;
data cereal2; set cereal;
   x1=(pkgdes eq 1)-(pkgdes eq 4);
   x2=(pkgdes eq 2)-(pkgdes eq 4);
   x3=(pkgdes eq 3)-(pkgdes eq 4);
   if (pkgdes eq 3)-(pkgdes eq 4) gt 0 
      then x3 = 1;
   if (pkgdes eq 3)-(pkgdes eq 4) lt 0 
      then x3 = -4/5;
proc print data=cereal2; run;

*run the regression;
proc reg data=cereal2; 
   model cases=x1 x2 x3;
run;

*run the ANOVA;
proc glm data=cereal; 
   class pkgdes;
   model cases=pkgdes;
run;
