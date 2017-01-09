*KNNL860.sas, two-way anova contrast using data in Table 19.7;

options nocenter;

data bread; 
	infile 'H:\Stat512\Datasets\CH19TA07.DAT';
  	input sales height width;
proc print data=bread; run;

proc glm data=bread;
   class height width;
   model sales=height width height*width;
   contrast 'middle vs others' 
      height -.5 1 -.5 
      height*width -.25 -.25 .5 .5 -.25 -.25;
   estimate 'middle vs others' 
      height -.5 1 -.5 
      height*width -.25 -.25 .5 .5 -.25 -.25;
   means height*width;
run;
quit;

