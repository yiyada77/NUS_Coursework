x=[1,0;1,0.8;1,1.6;1,3;1,4;1,5];
d=[0.5;1;4;5;6;8];

a=x'*x;
b=a^-1;
c=b*x'*d;
c
