function [ hasObject, choice ] = vicfar( data,value,KVI,KMR,pfa)
%data 为参考单元数据，value为有数据的点 ,KVI统计量VI阀值门限，统计量MR阀值门限
N=length(data); %参考单元长度
VI_before=1;
VI_after=1;
hasObject=0; %是否检测出目标
avg_x=mean(data);
for i=1:N/2
    %for i=1:N/2-1
   VI_before=VI_before+1/(N/2-1)*(data(i)-avg_x)^2/avg_x^2;
   VI_after=VI_after+1/(N/2-1)*(data(i+N/2)-avg_x)^2/avg_x^2;
  % VI_after=VI_after+1/(N/2-1)*(data(i+N/2+1)-avg_x)^2/avg_x^2;
end
MR=sum(data(1:N/2))/sum(data(N/2+1:N));

isAve_before=1;  %前半划窗是否是均匀环境，1为均匀
isAve_after=1;  %后半划窗是否是均匀环境，1为均匀
HasSameAve=1; %是否同均值,1为相同
if(VI_before>KVI)
    isAve_before=0;
end
if(VI_after>KVI)
    isAve_after=0;
end
if(MR<1/KMR&&MR>KMR)
    HasSameAve=0;    
end

CN=pfa^(-1/N)-1;
CN2=pfa^(-1/(N/2))-1;

%选用第一种策略
if(isAve_before==1 && isAve_after==1 && HasSameAve==1)
    hasObject=cacfar(data,value,CN);
    choice=1;
end
%选用第二种策略
if(isAve_before==1 && isAve_after==1 && HasSameAve==0)
    hasObject=gocfar(data,value,CN2);
    choice=2;
end
%选用第三种策略
if(isAve_before==0 && isAve_after==1)
    hasObject=cacfar(data(N/2+1:N),value,CN2);
    choice=3;
end
%选用第四种策略
if(isAve_before==1 && isAve_after==0)
    hasObject=cacfar(data(1:N/2),value,CN2);
    choice=4;
end
%选用第五种策略
if(isAve_before==0 && isAve_after==0)
    hasObject=socfar(data,value,CN2);
    choice=5;
end

end

