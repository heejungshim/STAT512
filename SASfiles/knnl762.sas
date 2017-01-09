*KNNL762.sas, quantitative factors using data in Table 16.1;
options nocenter;

data training; 
 infile 'H:\Stat512\Datasets\CH17TA06.DAT';
 input product trainhrs;
proc print data=training; run;
* Replace trainhrs by actual hours;
data training; set training; 
   hrs=2*trainhrs+4;
   hrs2=hrs*hrs;
proc print data=training; run;

proc glm data=training; 
   class trainhrs; 
   model product=hrs trainhrs / solution;
run;
symbol1 v = circle i = rl;
proc gplot data=training;
	plot product*hrs;
run;
proc glm data=training; 
   class trainhrs; 
   model product=hrs hrs2 trainhrs;
run;
quit;

