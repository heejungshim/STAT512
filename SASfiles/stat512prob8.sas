data one;
    input trt response @@;
    cards;
    1 20 1 23 1 22
    2 24 2 26 2 25
    3 26 3 27 3 27
    ;

* Regression Parameterization #1;
data two;
    set one;
    if trt = 1 then x1=1;
      else x1=0;
    if trt = 2 then x2=1;
      else x2=0;

* Regression Parameterization #2;
data three;
    set one;
    if trt = 1 then x1=1;
      else if trt = 3 then x1=-1;
        else x1=0;
    if trt = 2 then x2=1;
      else if trt = 3 then x2=-1;
        else x2=0;

proc glm data=one;
    class trt;
    model response=trt /solution;
    means trt;
proc reg data=two;
    model response=x1 x2;
proc reg data=three;
    model response=x1 x2;
run;
