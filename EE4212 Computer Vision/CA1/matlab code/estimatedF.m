function [F]=estimatedF(p,p_prime,N)
%normalization of the data
meanOfp=mean(p);
meanOfp_prime=mean(p_prime);
originOfp=p-meanOfp;
originOfp_prime=p_prime-meanOfp_prime;
%mean square distance
squareOfp=originOfp.^2;
squareOfp_prime=originOfp_prime.^2;
distanceOfp=mean(sqrt(squareOfp(1,:)+squareOfp(2,:)));%RMS
distanceOfp_prime=mean(sqrt(squareOfp_prime(1,:)+squareOfp_prime(2,:)));
scalingOfp=sqrt(2)./distanceOfp;%average distance from origin is sqrt(2)
scalingOfp_prime=sqrt(2)./distanceOfp_prime;
%T=translation+scaling 
T=[scalingOfp,0,-scalingOfp*meanOfp(1);
   0,scalingOfp,-scalingOfp*meanOfp(2);
   0,0,1];
T_prime=[scalingOfp_prime,0,-scalingOfp_prime*meanOfp_prime(1);
         0,scalingOfp_prime,-scalingOfp_prime*meanOfp_prime(2);
         0,0,1];
%normalize coordinates in images 
p_homo=[p;ones(1,N)];
p_prime_homo=[p_prime;ones(1,N)];
X=(T*p_homo)';
X_prime=(T_prime*p_prime_homo)';

%computation of fundamental matrix
A=zeros(N,9);
for i=1:N
    A(i,1)=X_prime(i,1)*X(i,1);
    A(i,2)=X_prime(i,1)*X(i,2);
    A(i,3)=X_prime(i,1);
    A(i,4)=X_prime(i,2)*X(i,1);
    A(i,5)=X_prime(i,2)*X(i,2);
    A(i,6)=X_prime(i,2);
    A(i,7)=X(i,1);
    A(i,8)=X(i,2);
    A(i,9)=1;
end
%SVD find solution of f
[U,D,V]=svd(A);
f=V(:,9);%last column of V
F=reshape(f,[3,3]);
F=F';
%enforce singularity constraint
[U_F,D_F,V_F]=svd(F);
D_FOfFrobenius=zeros(3,3);
D_FOfFrobenius(1,1)=D_F(1,1);
D_FOfFrobenius(2,2)=D_F(2,2);
D_F=D_FOfFrobenius;
F_prime=U_F*D_F*V_F';%replace F by F_prime

%denormlization
F=T_prime'*F_prime*T;%fundamental metrix F
end