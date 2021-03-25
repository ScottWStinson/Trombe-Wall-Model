% Trombe Wall Project
%Scott Stinson
%Alex Eslinger
clc,clear,close all;


days=input('How many days do you want to run this simulation? \n\n');
Tamb=xlsread('weather2',1,'G2:G25')+273.15;
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
Tamb=T;
qsolar=qs;
i=1;
T0(1)=20+273.15;
T6(1)=20+273.15;
k=0.7; %W/m K
% at t = 0
T1(1)=20+273.15;
T2(1)=20+273.15;
T3(1)=20+273.15;
T4(1)=20+273.15;
T5(1)=20+273.15;

while i<24*4*days

    T0(i+1)=0.1584*T1(i)+0.7386*T0(i)+30.1827;
    T1(i+1)=0.1584*T0(i)+0.1584*T2(i)+0.6832*T1(i);
    T2(i+1)=0.1584*T1(i)+0.1584*T3(i)+0.6832*T2(i);
    T3(i+1)=0.1584*T2(i)+0.1584*T4(i)+0.6832*T3(i);
    T4(i+1)=0.1584*T3(i)+0.1584*T5(i)+0.6832*T4(i);
    T5(i+1)=0.1584*T4(i)+0.1584*T6(i)+0.6832*T5(i);
    T6(i+1)=0.8071*T6(i)+0.1586*T5(i)+0.0086*qsolar(i)+0.0343*Tamb(i);
    i=i+1;
end


delx=0.05;
delt=900;
t=1:1:i;
n=1;
while n<=24*4*days
q(n)=(T6(n)-Tamb(n))*k/delx;
qinside(n)=abs(((20+273.15)-T0(n)))*k/delx;
n=n+1;
end

subplot(2,1,1);
hold on
plot(t,q,'r.-'); grid on
plot(t,qinside,'b.-');
title('Front and Back Surface Heat Flux as a Function of Time with Explicit Method')
xlabel('Time (15min or 900s)')
ylabel('Heat Flux W/m^2')
legend('q front','q inside','location','Northwest')
hold off

subplot(2,1,2);
plot(t,T0-273.15,t,T1-273.15,t,T2-273.15,t,T3-273.15,t,T4-273.15,t,T5-273.15,t,T6-273.15);
grid on
title('Nodal temperatures vs Time')
legend('T0','T1','T2','T3','T4','T5','T6','location','Northwest'); 
xlabel('Time (15min or 900s)') 
ylabel('Temperature in Celsius for each node')

% Calculate averge heat flux for the wall
qavgOut=sum(q)/(24*4*days);
qavgInside=sum(qinside)/(24*4*days);

fprintf('\nThe average heat flux through the outer wall is %0.2f W/m^2\n',qavgOut);
fprintf('The average heat flux through the inside wall is %0.2f W/m^2\n',qavgInside);

%Radiant Heat flux to outside, using highest surface temp
emis=0.85;
sigma=5.6703e-8;
radiantqout=emis*sigma*(T6(249)^4-Tamb(249)^4);
radiantqin=emis*sigma*(T6(249)^4-296.15^4);
fprintf('\nThe radiant heat flux to the surrounds if the temperature between the\n wall and the glass is the same as the ambient temperature is: %0.2f W/m^2\n',radiantqout);
fprintf('\nThe radiant heat flux to the surrounds if the temperature between the\n wall and the glass is the same as the indoor environment is: %0.2f W/m^2\n',radiantqin);

