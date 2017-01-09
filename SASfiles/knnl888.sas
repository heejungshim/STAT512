*KNNL888.sas, two-way anova with one observation per cell,
   Tukey one df for additivity, using data in Table 21.2;
options nocenter;

data carins; 
	infile 'H:\Stat512\Datasets\CH21TA02.DAT';
  	input premium size region;
proc print data=carins; 
run;

* Use SAS to get the factor effects model parameter estimates;
*get the overall mean;
proc glm data=carins; 
   model premium=;
   output out=overall p=muhat;
proc print data=overall;
run;

proc glm data=carins; 
   class size;
   model premium=size;
   output out=meanA p=muhatA;
proc print data=meanA;
run;

proc glm data=carins; 
   class region;
   model premium=region;
   output out=meanB p=muhatB;
proc print data=meanB;
run;

data estimates; 
	merge overall meanA meanB;
  	alpha = muhatA - muhat;
   	beta = muhatB - muhat;
   	atimesb = alpha*beta;
proc print data=estimates;
   var size region alpha beta atimesb;
run;

proc glm data=estimates;
   class size region;
   model premium=size region atimesb/solution;
run;
quit;

