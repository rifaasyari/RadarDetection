%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li %%%
%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%�������������߿ڱ�����ʯ����%%%%%%%%%%
function fallstone(T,f0,B,deltaR, deltaV)
c=3e8;
%%%%%%%%%ȷ���ֱ���%%%%%%%%%%%%%%
Rmax=300; %���������
Fs=4*B*Rmax/(T*c); %��Ƶ�źŲ�����
N=round(Fs*T); %����ά��������
M=fix(c/(deltaV*2*T*f0)); %�ٶ�ά��������
Vmax=M*deltaV;  %���ģ������
%%%%%%%%%%���ò���%%%%%%%%%%%%%%%%%%%%%%%
angle=3; %��λ�����Ƕ�
T1=M*T; %������פ��ʱ��
scan_angle=30:angle:150; %����ɨ��Ƕȷ�Χ
TT=T1*length(scan_angle); %ɨ�踲������һ����ʱ��
t=0:T1:25*TT; %����ɨ��ʱ��Ϊ10����

%%%%%%%%%%%%%%%��ʼ��mapͼ%%%%%%%%%%%%%%%%%
map=ones(fix(Rmax/0.1), 180)*(-1); %mapͼ����ά��С��ԪΪ0.1m���Ƕ�ά��С����Ϊ1��
%%%%%%%%%%%%%%%%%%%%%%%%%%
%   �����˶�ģ������     %
R0=70; %��ʼ����
v0=-4; %��ʼ�ٶ�,�ӽ��״﷽��Ϊ��
a=-3; %���ٶ�

sita0=50;%��ʼ�Ƕ�
sita_a=1;%�Ƕȱ仯���ٶ�
sita_v0=1;%�Ƕȱ仯��ʼ�ٶ�

v=v0+a.*t;
R=R0-(v0.*t + 0.5*a.*t.^2);
sita=sita0 + sita_v0.*t + 0.5*sita_a.*t.^2;

%      ��ֹ����         %
R1=72;sita1=50;
%R2=80;sita2=50;
%                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%
map(fix(R0/0.1), sita0)=abs(v0);
map(fix(R1/0.1), sita1)=0;
%map(fix(R2/0.1), sita2)=0;

R_pre=fix(R0/0.1); %map����ʱ��Ӧ����һʱ�̵�ֵ
sita_pre=sita0;

%%%%%%%%%%%%%ɨ��map�õ��ز�������%%%%%%%%%%%%%
search_sita=30;
for i=1:length(t)
    %ʵʱ����map
    [map, R_pre, sita_pre] = updatemap(map, R(i)/0.1, R_pre, sita(i), sita_pre, abs(v(i)));
    %��ûز���Ƶ�ź�
    response=getresponse(map,0.1,angle,search_sita,M,T,Fs,B,f0);
    
    if response
        %�����������Ӳ�
        SNR=1; %�����������
        response = awgn(response, SNR);
        %�����Ӳ��ź�
        za=zeros(M,N);
%         Z=terrain; %���ɵ������ݾ���
%         hangza=zabo(B,f0,fs,T,B/T,3,Rmax,Z);
        for k=1:M
            za(k,:)=wbfb(1.5,2.2);
        end
        response = response + (za);
        
        %%%%%%%%%%�Բ�Ƶ�źŽ��ж�άfft�任%%%%%%%%%
        data = after2fft(response, N, Fs, T, B, f0); %��ά�任��ľ���
        data=abs(data);
        %ȥ����Ƶ�ʵ��Ӳ��뾲ֹ����
        for i=1:N
            data(1,i)=data(2,i);
        end
        
        %%%%%%%%%%%%%CFAR����%%%%%%%%%%%%%%%
        hasObject = cfarhandled(data,search_sita,deltaR);
%         x_distance=(linspace(0,Fs*(N-1)/N,N));
%         y_velocity=linspace(0, 1/T*(M-1)/M, M);
%         meshx=x_distance(1:N/2)*c/(2*B/T);
%         figure;
%         mesh(meshx,c*y_velocity/(2*f0),hasObject);
%         title('���龯�����');
%         xlabel('distance/m');
%         ylabel('velocity/(m/s)');
    end
    %%%%%%%%������λ��%%%%%%%%%%
    disp('��ǰ����ɨ��Ƕ�Ϊ��');
    search_sita = search_sita + angle %����ָ����һ����λ
    if(search_sita > 150)
        search_sita = 30;
    end
end
%�켣����
end