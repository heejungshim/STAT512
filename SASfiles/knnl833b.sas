*KNNL833b.sas, two-way anova using data in Table 19.7;
options nocenter;
data bread; 
	infile 'H:\Stat512\Datasets\CH19TA07.DAT';
	input sales height width;
proc print data=bread; run;

proc glm data=bread;
   class height width;
   model sales=height width height*width/solution;
   means height*width;
run;
quit;
proc glm data=bread;
   class height width;
   model sales=height width height*width;
   output out=breadiag r=resid;
run;

proc rank data=breadiag 
 	out=quantiles normal=blom;
	var resid;
	ranks zresid;
proc sort data=quantiles; 
   by zresid;
symbol1 v=circle i=sm70;
proc gplot data=quantiles;
   plot resid*zresid;
run;

proc glm data=bread;
   class height width;
   model sales=height width;
   means height / tukey lines;
run;
quit;
