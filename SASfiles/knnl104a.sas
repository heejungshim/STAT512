*KNNL104a.sas;
options nocenter;

Data het; 
   do x=1 to 100; 
      y=100*x+30+10*x*normal(0);
      output;
   end;
run;

proc reg data=het;
   model y=x;
   output out=a3 r=resid;
run;
symbol1 v=circle i=sm60;
proc gplot data=a3;
   plot y*x/frame;
proc gplot data=a3;
   plot resid*x/vref=0;
run;
quit;
