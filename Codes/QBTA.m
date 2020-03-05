n=5;
ETX=50*0.000000001;
ERX=50*0.000000001;
Efs=10*0.000000000001;
Emp=0.0013*0.000000000001;
EDA=5*0.000000001;
do=sqrt(Efs/Emp);
p=randperm(9);
w=1;
for i=1:1:n
     S(i).q=p(i);
     S(i).E=rand;
end
for i=1:1:n
    for j=1:1:S(i).q
        Q(i,j)=3+randn(1);
    end
end
f=@()press();
h(w)=timeit(f);
w=w+1;
f=@()press1();
h(w)=timeit(f);
w=w+1;
f=@()press2();
h(w)=timeit(f);
w=w+1;
f=@()press3();
h(w)=timeit(f);
X=sort(h);
for i=1:1:w
    b(i,1)=X(1,i);
end
for j=1:1:w
    tic
    max_e=0;
    for i=1:1:n
        if(max_e==0)
            k=max_e;
        else
            k=S(max_e).E;
        end
        if(S(i).E>k)
            max_e=i;
        end
    end
    toc
S(max_e).E=0;
S(max_e).q=S(max_e).q+1;
Q(max_e,S(max_e).q)=X(1,j);
b(j,5)=max_e;
b(j,2)=(toc-tic)*1000;
end
for i=1:1:n
    for j=1:1:S(i).q
        Q(i,j)=round(Q(i,j))
    end
end
%------------------FCFS--------------------------
%b(1,3)=0;
for i=1:1:w
 for x=1:1:S(b(i,5)).q
     a(x,1)=Q(b(i,5),x);
 end
 a(1,2)=0;
    for k=2:1:S(b(i,5)).q
    a(k,2)=0;
    for j=1:1:k-1
        a(k,2)=a(k,2)+a(j,1);
    end
    end
for j=1:1:S(b(i,5)).q
    a(j,3)=a(j,1)+a(j,2);
end
b(i,3)=a(S(b(i,5)).q,2);
b(i,4)=a(S(b(i,5)).q,3);
if (i~=w)
for g=1:1:10
    a(g,1)=0;
    a(g,2)=0;
    a(g,3)=0;
end
end
end
%-------------------------------------------------
%------------------RR-----------------------------
for g=1:1:w
    for h=1:1:S(b(g,5)).q
        btime(1,h)=Q(b(g,5),h);
    end
    m=S(b(g,5)).q;
%btime=[2 4 3 1 3];	%burst time		
q=2;                %quantum time
tatime=zeros(1,m);	%turn around time
wtime=zeros(1,m);   %waiting time
rtime=btime;        %intially remaining time= waiting time
b1=0;
t=0;
flag=0;             %this is set if process has burst time left after quantum time is completed
for i=1:1:m         %running the processes for 1 quantum 
    if(rtime(i)>=q)
%         fprintf('P%d\n',i);
        for j=1:1:m
            if(j==i)
                rtime(i)=rtime(i)-q;    %setting the remaining time if it is the process scheduled
            else if(rtime(j)>0)
                    wtime(j)=wtime(j)+q;    %incrementing wait time if it is not the process scheduled
                end
            end
        end
    else if(rtime(i)>0)             
%             fprintf('P%d\n',i);
            for j=1:1:m
              if(j==i)
                rtime(i)=0;                 %as the remaining time is less than quantum it will run the process and end it
              else if(rtime(j)>0)
                    wtime(j)=wtime(j)+rtime(i);     %incrementing wait time if it is not the process scheduled
                  end 
              end
            end
        end
    end
end
for i=1:1:m
    if(rtime(i)>0)      %if remaining time is left set flag
        flag=1;
    end
end
while(flag==1)          %if flag is set run the above process again
    flag=0;
    for i=1:1:m
        if(rtime(i)>=q)
%             fprintf('P%d\n',i);
            for j=1:1:m
                if(j==i)
                    rtime(i)=rtime(i)-q;
                else if(rtime(j)>0)
                        wtime(j)=wtime(j)+q;
                    end
                end
            end
        else if(rtime(i)>0)
%                 fprintf('P%d\n',i);
                for j=1:1:m
                    if(j==i)
                        rtime(i)=0;
                    else if(rtime(j)>0)
                            wtime(j)=wtime(j)+rtime(i);
                        end 
                    end
                end
            end
        end
    end
    for i=1:1:m
        if(rtime(i)>0)
            flag=1;
        end
    end
end
for i=1:1:m
    tatime(i)=wtime(i)+btime(i);    %calculating turn around time for each process by adding waiting time and burst time
end
% disp('Process   Burst time  Waiting time    Turn Around time'); %displaying the final values
for i=1:1:m
%     fprintf('P%d\t\t\t%d\t\t\t%d\t\t\t\t%d\n',(i+1),btime(i),wtime(i),tatime(i));
    b1=b1+wtime(i);
    t=t+tatime(i);
end
b(g,6)=wtime(m);
b(g,7)=tatime(m);

% fprintf('Average waiting time: %f\n',(b/n));
% fprintf('Average turn around time: %f\n',(t/n));
end

%-------------------graph
b(1,8)=1;
b(2,8)=2;
b(3,8)=3;
b(4,8)=4;
hold off;
plot(b(:,8),b(:,4),'-g.'); hold on;
plot(b(:,8),b(:,7),'-r.') 
     %axis([0 2*pi -1.5 1.5])
     legend('Based on sequence in queue','Based on quantum','Location','NorthEast')
     xlabel('task')
     ylabel('time(sec)')
 hold on