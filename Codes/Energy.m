xm=100;
ym=100;
base.x=1.5*xm;
base.y=0.5*ym;
n=10;
%Energy Model (all values in Joules)
%Initial Energy 
%Eo=0.1;
%Eelec=Etx=Erx
ETX=50*0.000000001;
ERX=50*0.000000001;
%Transmit Amplifier types
Efs=10*0.000000000001;
Emp=0.0013*0.000000000001;
%Data Aggregation Energy
EDA=5*0.000000001;
z=1;
%rmax=20; %no of rounds
do=sqrt(Efs/Emp);
f = @() press(); % handle to function
h = timeit(f) ;
S(1).E=0.4709;
S(2).E=0.1948;
S(3).E=0.2277;
S(4).E=0.9234;
S(5).E=0.9049;
S(6).E=0.1111;
S(7).E=0.5949;
S(8).E=0.7112;
S(9).E=0.2967;
S(10).E=0.5079;
figure(1);
hold off;
for i=1:1:n
    S(i).xd=rand(1,1)*xm;
    %XR(i)=S(i).xd;
    S(i).yd=rand(1,1)*ym;
    %YR(i)=S(i).yd;
    S(i).energy=S(i).E;
  % plot(S(i).xd,S(i).yd,'o');
   hold on;
end

S(n+1).xd=base.x;
S(n+1).yd=base.y;
%plot(S(n+1).xd,S(n+1).yd,'o', 'MarkerSize', 12, 'MarkerFaceColor', 'r');

for j = 0:h
    max_e=0;
    dist=0;         
 for i=1:1:n
     if (max_e==0) 
         k=max_e;
     else
         k=S(max_e).E;
     end   
   if(S(i).E>k)
      
       max_e=i;
   end
 end
 d=S(max_e).E;
 F(z).c=max_e;
while ( d >= 0 && j <= h )
  distance=sqrt( (S(max_e).xd-(S(n+1).xd) )^2 + (S(max_e).yd-(S(n+1).yd) )^2 );
  if (distance>do)
  S(max_e).E=S(max_e).E- ( (ETX+EDA)*(4000) + Emp*4000*( distance*distance*distance*distance )); 
  d=S(max_e).E;
  end
                if (distance<=do)
                S(max_e).E=S(max_e).E- ( (ETX+EDA)*(4000)  + Efs*4000*( distance * distance )); 
                d=S(max_e).E;
                end
   j=j+0.0008;
   
end 
F(z).t=j-0.0008;
z=z+1;
end
hold off
% for i=1:1:z-1
%  % make sure no new plot window is created on every plot command
% %axes(); % produce plot window with axes
% plot(F(i).c,F(i).t,'o')
% xlim([0 10])
% ylim([0 5])
% hold on
% end
for i=1:1:z-1
X(i,1)=F(i).c;
X(i,2)=F(i).t;
end
plot(X(:,1), X(:,2:end),'-r.')
xlabel('NODENUMBER')
ylabel('TIME(SEC)')
% x=[F(:,1) F(:,3)];
% y=[F(:,2) F(:,4)];
% plot(x,y)
hold on
