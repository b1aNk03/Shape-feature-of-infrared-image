clearvars
%% var
global S K N row_ori column_ori row_com column_com;
global check_theta check_M00 check_M10 check_M01;
S = 48;                               %特征邻域窗口大小
K = 5;                                %高斯滤波半径
N = 256;                              %特征位数
level = 3;                            %金字塔层数
threshold_FAST = 0;                   %FAST使用的阈值
threshold_HARRIS = 0.001;             %HARRIS使用的阈值400
global cnt_ori cnt_com;               %特征点数目
cnt_ori = zeros(1, 100);
cnt_com = 0;
diff = 110;
id = 0;                               %临时的变量
%% main
I_ori = rgb2gray(imread('C:\Users\张泽鋆\Desktop\plane1.bmp'));     %原始图像
I_com = rgb2gray(imread('C:\Users\张泽鋆\Desktop\plane1_rotated.bmp'));  %需要检测的目标图像
%I_com = rgb2gray(imread('C:\Users\ZZ jun\Desktop\plane1_rotated.bmp'));  %需要检测的目标图像

[row_ori, column_ori] = size(I_ori);
[row_com, column_com] = size(I_com);                      %图像的尺寸

[I_ori_p, gra_ori] = Initialize(I_ori);                           %预处理图像
[I_com_p, gra_com] = Initialize(I_com);

%Shape_context(I_ori_p, I_com_p, gra_ori, gra_com);

% H_P=projective2d([0.765,   -0.122,  -0.0002;
%                  -0.174,   0.916,   9.050e-05;
%                   105.018, 123.780, 1]);
% I_com_p = imwarp(I_com_p, H_P);
% [row_com, column_com] = size(I_com_p); 

Pyramid = Construct_Pyramid(I_ori_p, level);                %构建图像金字塔，输入图像和金字塔层数
%tic
Points_Pyramid = zeros(2, 100, 10);
gauss_filter = fspecial('gaussian', [5, 5], 0.5);                 %归一化的高斯滤波器
for i = 1 : level + 1
    Points_Pyramid(:, :, i) = FAST(Pyramid(:, :, i), threshold_FAST, i); 
    %Points_Pyramid(:, :, i) = HARRIS(Pyramid(:, :, i), threshold_HARRIS, gauss_filter, i); 
end
Points_com = FAST(I_com_p, threshold_FAST, 0);                   %FAST算法得到特征点，输入金字塔和层数 
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
Descriptor_com = ORB(Points_com, I_com_p, 0, s);   %计算得到orb描述子

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
    Match(Points_com, Points_Pyramid(:, :, i), I_com_p, Pyramid(:, :, id), Descriptor_com, Descriptor_ori, id, 2);  %特征点匹配,1表示前面的串是三维，2表示后面是三维
end