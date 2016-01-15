%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li %%%
%%%%%%%%%%%%%%%%%%%%%%%
close all;
clear all;
%建立多目标运动物体模型
deltat=0.2;
t=0:deltat:3;
%   物体运动模型设置     %
%[实时速度，实时距离，实时角度] = mbpara(初始距离，初始速度，加速度，初始角度，角度变化加速度，角度变化初始速度）
[v1, R1, sita1] = mbpara(70,-4,-3,50,1,1,t); %一个动物体以及多点
[v1_1, R1_1, sita1_1] = obmutipoint(R1,v1,sita1,2, deltat);
[v1_2, R1_2, sita1_2] = obmutipoint(R1,v1,sita1,-2,deltat);

[v2, R2, sita2] = mbpara(130,2,2,90,1,2,t); %一个动物体以及多点
[v2_1, R2_1, sita2_1] = obmutipoint(R2,v2,sita2,1,deltat);
[v2_2, R2_2, sita2_2] = obmutipoint(R2,v2,sita2,-1,deltat);

% %      静止物体         %
% R4=72;sita4=50;
% %R2=80;sita2=50;
% %                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%
polar(sita2/180*pi, R2,'*');
hold on;
polar(sita2_1/180*pi,R2_1,'r');
hold on;
polar(sita2_2/180*pi,R2_2,'g');

hold on;

polar(sita1/180*pi, R1,'*');
hold on;
polar(sita1_1/180*pi,R1_1,'r');
hold on;
polar(sita1_2/180*pi,R1_2,'g');

distanceData = [R1;R1_1;R1_2;R2;R2_1;R2_2];
velocityData = [v1;v1_1;v1_2;v2;v2_1;v2_2];
angleData = [sita1;sita1_1;sita1_2;sita2;sita2_1;sita2_2];
%点迹聚合
distanceDoor = 4; %距离门
angleDoor=3; %方位门
velocityDoor = 2; %速度门
object = cell(1,length(t)); %每个扫描段的目标凝聚结果
for n = 1:length(t)
    X=[distanceData(:,n) velocityData(:,n)];
    [class, type] = dbscan(X,2,[]);
    clusternum = class(end);%簇的个数
    objectnum = size(X,1); %出现目标的个数
    objectcell=cell(1, clusternum); %存放各个簇的cell单元
    objectsize = zeros(1, clusternum);%每个簇的物体大概尺寸
    
    
    %把目标分别分到对应的cell簇单元中
    for i = 1:objectnum
        if(isempty(objectcell{class(i)}))
            objectcell{class(i)} = X(i,:);
        else
            objectcell{class(i)} = [objectcell{class(i)};X(i,:)];
        end    
    end
    %更新每个簇的目标大概尺寸，根据k-means方法目标凝聚
    for i = 1:clusternum
      dis = objectcell{i}(:,1); %取簇中的距离维
      vel = objectcell{i}(:,2); %取簇中的速度维
      objectsize(i) = max(dis)-min(dis);
      
      object{n} = [object{n};mean(dis) mean(vel)];
    end    
 end

%航迹起始

%航迹维持

%航迹管理