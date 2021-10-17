clearvars
S = 48;     %特征邻域窗口大小
K = 9;      %高斯滤波半径
N = 256;    %特征位数
graph = imread('C:\Users\ZZ jun\Desktop\plane1.bmp');
graph = rgb2gray(graph);
imshow(graph)
[n, m] = size(graph);

p = detectHarrisFeatures(graph);
p = p.Location;

p = p(p(:, 1) > S & p(:, 1) < n - S & p(:, 2) > S & p(:, 2) < m - S, :);

H = fspecial('gaussian', [K K], 2);
graph=imfilter(graph, H, 'replicate');

s = normrnd(0, S/5, N, 4);
figure;
for i = 1 : N
   plot(s(i, 1 : 2), s(i, 3 : 4));    
   hold on;
end

tao = zeros(length(p), N);
for i=1 : length(p)
    px = round(p(i, :) + s(:, 1 : 2));
    py = round(p(i, :) + s(:, 3 : 4));
    
    for j = 1 : N
        if graph(px(j, 2), px(j, 1)) < graph(py(j, 2), py(j, 1)) 
            tao(i, j) = 1;
        else
            tao(i, j) = 0;
        end
    end
    
    graph(round(p(i, 2)), round(p(i, 1))) = 255;
end
figure;
imshow(graph)

figure;
imshow(tao)