%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li %%%
%%%%%%%%%%%%%%%%%%%%%%%

function point = threePredict(point1, point2, point3, t)
%���������״̬��Ϣ���е��������Ԥ��,ÿ����Ϊһ�����������ֱ�Ϊ���룬�ٶȣ���λ��ʱ��
Rs2 = point2(1); %�Եڶ���ľ������
Fs2 = point2(3); %�Եڶ���ķ�λ����
T=point2(4)-point1(4); %����֮���ʱ���
Vs2 = (point2(1) - point1(1))/T; %�Եڶ�����ٶȹ���
Fvs2 = (point2(3) - point1(3))/T; %�Եڶ���ķ�λ�仯�ٶȹ���
Rp3 = Rs2 + (t - point2(4)) * Vs2; %�Ե���������Ԥ��
Vp3 = Vs2; %�Ե������ٶȵ�Ԥ��
Fp3 = Fs2 + (t - point2(3)) * Fvs2; %�Ե�����ķ�λ��Ԥ��
point = [Rp3 Vp3 Fp3 t];
end