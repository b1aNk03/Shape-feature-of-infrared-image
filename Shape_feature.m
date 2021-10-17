clearvars
%% var
global S K N row_ori column_ori row_com column_com;
global check_theta check_M00 check_M10 check_M01;
S = 48;                               %�������򴰿ڴ�С
K = 5;                                %��˹�˲��뾶
N = 256;                              %����λ��
level = 3;                            %����������
threshold_FAST = 0;                   %FASTʹ�õ���ֵ
threshold_HARRIS = 0.001;             %HARRISʹ�õ���ֵ400
global cnt_ori cnt_com;               %��������Ŀ
cnt_ori = zeros(1, 100);
cnt_com = 0;
diff = 110;
id = 0;                               %��ʱ�ı���
%% main
I_ori = rgb2gray(imread('C:\Users\�����]\Desktop\plane1.bmp'));     %ԭʼͼ��
I_com = rgb2gray(imread('C:\Users\�����]\Desktop\plane1_rotated.bmp'));  %��Ҫ����Ŀ��ͼ��
%I_com = rgb2gray(imread('C:\Users\ZZ jun\Desktop\plane1_rotated.bmp'));  %��Ҫ����Ŀ��ͼ��

[row_ori, column_ori] = size(I_ori);
[row_com, column_com] = size(I_com);                      %ͼ��ĳߴ�

[I_ori_p, gra_ori] = Initialize(I_ori);                           %Ԥ����ͼ��
[I_com_p, gra_com] = Initialize(I_com);

%Shape_context(I_ori_p, I_com_p, gra_ori, gra_com);

% H_P=projective2d([0.765,   -0.122,  -0.0002;
%                  -0.174,   0.916,   9.050e-05;
%                   105.018, 123.780, 1]);
% I_com_p = imwarp(I_com_p, H_P);
% [row_com, column_com] = size(I_com_p); 

Pyramid = Construct_Pyramid(I_ori_p, level);                %����ͼ�������������ͼ��ͽ���������
%tic
Points_Pyramid = zeros(2, 100, 10);
gauss_filter = fspecial('gaussian', [5, 5], 0.5);                 %��һ���ĸ�˹�˲���
for i = 1 : level + 1
    Points_Pyramid(:, :, i) = FAST(Pyramid(:, :, i), threshold_FAST, i); 
    %Points_Pyramid(:, :, i) = HARRIS(Pyramid(:, :, i), threshold_HARRIS, gauss_filter, i); 
end
Points_com = FAST(I_com_p, threshold_FAST, 0);                   %FAST�㷨�õ������㣬����������Ͳ��� 
%Points_com = HARRIS(I_com_p, threshold_HARRIS, gauss_filter, 0);

s = normrnd(0, S/5, 4, N);
%Check_s(s, 5)
Descriptor_ori = zeros(100, N, 10);
check_theta = zeros(10, 10);
check_M00 = zeros(10, 10);
check_M10 = zeros(10, 10);
check_M01 = zeros(10, 10);
for i = 1 : level + 1
    if(cnt_ori(i) == 0)
        continue;
    end
    Descriptor_ori(1 : cnt_ori(i), :, i) = ORB(Points_Pyramid(:, :, i), Pyramid(:, :, i), i, s);
end
Descriptor_com = ORB(Points_com, I_com_p, 0, s);   %����õ�orb������

for i = 1 : level + 1
    if (abs(cnt_ori(i) - cnt_com) < diff)
        diff = abs(cnt_ori(i) - cnt_com);
        id = i;
    end
end
if (cnt_ori(id) <= cnt_com)
    Match(Points_Pyramid(:, :, id), Points_com, Pyramid(:, :, id), I_com_p, Descriptor_ori, Descriptor_com, id, 1);
    %toc
else
    Match(Points_com, Points_Pyramid(:, :, i), I_com_p, Pyramid(:, :, id), Descriptor_com, Descriptor_ori, id, 2);  %������ƥ��,1��ʾǰ��Ĵ�����ά��2��ʾ��������ά
end