*KNNL734.sas, one way anova using data in Table 16.1;
options nocenter;
data cereal; 
   infile 'H:\Stat512\Datasets\CH16TA01.DAT';
   input cases pkgdes store;
proc print data=cereal;
*Create a scatterplot;
symbol1 v=circle i=none;
proc gplot data=cereal; 
 plot cases*pkgdes;
run;

*Generate a plot of the means;
proc means data=cereal; 
 var cases; by pkgdes;
 output out=cerealmeans mean=avcases;
proc print data=cerealmeans;

symbol1 v=circle i=join;
proc gplot data=cerealmeans; 
 plot avcases*pkgdes;
run;

*Create 95% CI for each factor level.
  Uses each factor level standard std deviation;
proc means data=cereal mean std stderr clm maxdec=2; 
   class pkgdes;
   var cases;
run;

*Create 95% CI for each factor level.
  Uses pooled variance;
proc glm data=cereal; 
   class pkgdes; 
   model cases=pkgdes;
   means pkgdes/t clm; 
run;

*Create 95% CIs using bonferonni adjustment;
proc glm data=cereal; 
   class pkgdes; 
   model cases=pkgdes;
   means pkgdes/bon clm; 
run;

*Comparison of means using various adjustments;
proc glm data=cereal; 
   class pkgdes; 
   model cases=pkgdes;
   means pkgdes/lsd tukey bon scheffe; 
   means pkgdes/lines tukey; 
run;
