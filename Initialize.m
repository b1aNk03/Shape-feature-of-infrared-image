function [I_out, gra] = Initialize(I_in)
%% image enhancement
    I = double(I_in);
    [n, m] = size(I);
    num = zeros(1, 256);
    for i = 1 : n
        for j = 1 : m
            num(I(i, j) + 1) = num(I(i, j) + 1) + 1;
        end
    end
    maximum = -1;
    grey = 0;
    for i = 1 : 241
        summation = 0;
        for j = 0 : 14
            summation = summation + num(i + j);
        end
        if summation > maximum
            grey = i;
            maximum = summation;
        end
    end
    if grey >= 1 && grey < 76
        gamma = 0.5;
    elseif grey >= 76 && grey < 101
        gamma = 1;
    elseif grey >= 101 && grey < 151
        gamma = 1.5;
    elseif grey >= 151 && grey <= 241
        gamma = 3.5;
    end
    alpha = 255 ^ (1 - gamma);
    I = alpha * (I .^ gamma);
%     figure
%     imshow(uint8(I))
%     title('enhancement')
%% image sharpening
%     H = zeros(K, K);
%     D0 = 1.5;
%     N = 4;
%     for i  = 1 : K
%         for j = 1 : K
%             D = sqrt((i - K / 2) ^ 2 + (j - K / 2) ^ 2);
%             H(i, j) = 1 / (1 + (D0 / D) ^ (2 * N));
%         end
%     end
%     H = 10 + 2 * H;
%     H = H / sum(sum(H));
%     I_out = imfilter(I, H, 'replicate');
    I_out = Improved_sharpening(I);
%     figure
%     imshow(uint8(I_out))
%     title('sharpening')
%% calculate gradient for shape context
    windowy = [-1, -1, -1; 0, 0, 0; 1, 1, 1];
    windowx = [1, 0, -1; 1, 0, -1; 1, 0, -1];
    gra_x = imfilter(I_out, windowx);
    gra_y = imfilter(I_out, windowy);
    gra = atan(gra_x ./ gra_y);
%% contour extraction
    graph = double(I_out);
    [n, m] = size(graph);
    threshold = graythresh(uint8(graph)) + 60 / 256;
    graph = imbinarize(graph, 256 * threshold);
    
    BW = imfill(graph, 'holes');
    x = ones(3, 3);
    BW = imdilate(BW, x, 'same');
    BW = bwperim(BW);
%     figure
%     imshow(BW)
%     title('contour')
    I_out = BW;
    
%     dx = [-1, -1, -1, 0, 0, 1, 1, 1];
%     dy = [-1, 0, 1, -1, 1, -1, 0, 1];
%     res = graph;
%     for i  = 2 : n - 1
%         for j = 2 : m - 1
%             s = 0;
%             for k = 1 : 8
%                 nx = i + dx(k);
%                 ny = j + dy(k);
%                 s = s + graph(nx, ny);
%             end
%             if s == 8
%                 res(i, j) = 0;
%             end
%         end
%     end
%     figure
%     imshow(res)
%     title('contour')
%     I_out = res;
end