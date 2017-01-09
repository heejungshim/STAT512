*knnl783.sas, weighted least squares using data in Table 18.2;
options nocenter;

data solder; 
	infile 'H:\Stat512\Datasets\CH18TA02.DAT';
   input  strength type;
proc print data=solder; 
run;

proc means data=solder; 
   var strength;
   by type;
   output out=weights var=s2;
data weights; 
	set weights; 
	wt=1/s2;
data wsolder; 
	merge solder weights; 
	by type; 
proc glm data=wsolder; 
   class type; 
   model strength=type;
   weight wt; 
run;

