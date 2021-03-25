clc,clear,close all;
days=input('How many days do you want to run this simulation? \n\n');
Tamb=xlsread('weather2',1,'G2:G25');
qsolar=xlsread('weather2',1,'I2:I25');
i=1;
u=1;
d=1;
n=1;
while d <= days
    while n<=24
        while i<=4
            T(u)=Tamb(n);
            qs(u)=qsolar(n);
            i=i+1;
            u=u+1;
        end
        n=n+1;
        i=1;
    end
    n=1;
    d=d+1;
end
T=T';
qs=qs';