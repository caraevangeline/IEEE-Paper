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
w=1;

%rmax=20; %no of rounds
do=sqrt(Efs/Emp);
f = @() press(); % handle to function
h(w) = timeit(f) ;
w=w+1;
f = @() press1(); % handle to function
h(w) = timeit(f) ;
w=w+1;
f = @() press2(); % handle to function
h(w) = timeit(f) ;
w=w+1;
f = @() press3(); % handle to function
h(w) = timeit(f) ;
w=w+1;
f = @() press4(); % handle to function
h(w) = timeit(f) ;
w=w+1;
X=sort(h);
figure(1);
hold off;
p=randperm(15);
for i=1:1:n
    S(i).xd=rand(1,1)*xm;
    %XR(i)=S(i).xd;
    S(i).yd=rand(1,1)*ym;
    S(i).E=rand;
    S(i).q=p(i);
    %YR(i)=S(i).yd;
    S(i).energy=S(i).E;
  % plot(S(i).xd,S(i).yd,'o');
   hold on;
end
for i=1:1:n
    for j=1:1:S(i).q
        Q(i,j) = 3+randn(1);
    end
end

S(n+1).xd=base.x;
S(n+1).yd=base.y;
%plot(S(n+1).xd,S(n+1).yd,'o', 'MarkerSize', 12, 'MarkerFaceColor', 'r');
for i=1:1:w-1
    T(1,i)=X(1,i);
end


for b=1:1:w-1
  
for j = 0:X(1,b)
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
 
 if(S(max_e).q>12)
     if (Q(max_e,S(max_e).q)>3)
         S(max_e).E=0;
     else
         T(1,b)=T(1,b)+Q(max_e,S(max_e).q);
     end
 end
 d=S(max_e).E;    
while ( d >= 0 && j <= X(1,b) && S(max_e).q< 12)
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
if(S(max_e).q <12)
    F(z).c=max_e;
    F(z).t=j-0.0008;
    z=z+1;
end
end
for d=1:1:n
    if(S(d).E == 0)
    S(d).E=S(d).energy;
    end
end    
end
% hold off
% for i=1:1:z-1
%  % make sure no new plot window is created on every plot command
% %axes(); % produce plot window with axes
% plot(F(i).c,F(i).t,'o')
% xlim([0 10])
% ylim([0 5])
% hold on
% end
% for i=1:1:z
% X(i,1)=F(i).c;
% X(i,2)=F(i).t;
% end
% plot(X(:,1), X(:,2:end),'-r.')
% % x=[F(:,1) F(:,3)];
% % y=[F(:,2) F(:,4)];
% % plot(x,y)
% hold on
for i = 1:1:w-1
    A(i,1)=i;
    A(i,2)=X(1,i);
    B(i,1)=i;
    B(i,2)=T(1,i);
end
plot(A(:,1),A(:,2:end),'k'); hold on;
plot(B(:,1),B(:,2:end),'-r.') 
     %axis([0 2*pi -1.5 1.5])
     legend('actualtime','estimatedtime','Location','NorthEast')
     xlabel('TASKNUMBER')
     ylabel('TIME(SEC)')
 hold on