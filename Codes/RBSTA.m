rng(0,'twister');
n=5

r = randi([1 5],1,n);
co=0;
%r=[3 2 2]
for i=1:1:n
    z=1
    y=3*r(i)
    x=randi([1 7],1,y)
    for j=1:1:r(i)
        for k=1:1:3
            max(j,k,i)=x(z)
            z=z+1
        end
    end
end

for i=1:1:n
    z=1
    y=3*r(i)
    x=randi([0 5],1,y)
    for j=1:1:r(i)
        for k=1:1:3
            if x(z)<=max(j,k,i)
            alloc(j,k,i)=x(z)
            else
                alloc(j,k,i)=max(j,k,i)-1
            end
            z=z+1
        end
    end
end
for i=1:1:n
    r(i)=r(i)+1
    max(r(i),1,i)=4
    max(r(i),2,i)=4
    max(r(i),3,i)=3
    alloc(r(i),1,i)=0
    alloc(r(i),2,i)=0
    alloc(r(i),3,i)=0
    
end


for i=1:1:n
    for j=1:1:3
        sum=0
        for k=1:1:r(i)
            sum=sum+alloc(k,j,i)
        end
        avail(i,j)=sum-3
    end
end











for k=1:1:n
    
for i=1:1:r(k)
    for j=1:1:3
        need(i,j,k)=max(i,j,k)-alloc(i,j,k);
    end
end
end


for k=1:1:n
    count =1;
process=0;
for i=1:1:r(k)
    completed(i)=0;
end
 while count~=r(k)+1 && process~=-1
           process=-1;
           for i=1:1:r(k)
               if(completed(i)==0)
                   process=i;
                   for j=1:1:3
                       if(avail(k,j)<need(i,j,k))
                           process=-1;
                           break;
                       end
                   end
               end
               if process~=-1
                   break;
               end
           end
           if process~=-1
               safeseq(k,count)=process;
               count=count+1;
               co=co+1
               for j=1:1:3
                   avail(k,j)=avail(k,j)+alloc(process,j,k);
                   alloc(process,j,k)=0;
                   max(process,j,k)=0;
                   completed(process)=1;
               end
           end
end
end



s=randi([1 4],1,co);
y=1;

for i=1:1:n
    z=r(i);
    for j=1:1:6
        if safeseq(i,j)==0
            break;
        end
        t(i,j)=s(y);
        if safeseq(i,j)==z
            t(i,j)=2;
        end
        y=y+1;
    end
end
for i=1:1:n
    sum=0;
    y=r(i);
   
    for j=1:1:6
       sum=sum+t(i,j);
        if safeseq(i,j)==y
            break;
        end
    end
    safeseq(i,7)=sum;
end