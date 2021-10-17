function p_out = HARRIS(I_in, threshold, gauss_filter, Flag)
    global cnt_ori cnt_com S;
    graph = double(I_in);
    [n, m] = size(graph);
    windowx = [-1, 0, 1; -1, 0, 1; -1, 0, 1];
    windowy = windowx';
    p_out = zeros(2, 100);
    cnt = 0;
    localmax = zeros(n, m);
%%
    Ix = imfilter(graph, windowx);
    Iy = imfilter(graph, windowy);
    Ix2 = Ix .* Ix;
    Iy2 = Iy .* Iy;
    Ixy = Ix .* Iy;

    
    Ix2 = imfilter(Ix2, gauss_filter);
    Iy2 = imfilter(Iy2, gauss_filter);
    Ixy = imfilter(Ixy, gauss_filter);

    R = (Ix2 .* Iy2 - Ixy .* Ixy) ./ (Ix2 + Iy2 + 0.00001);

    for i = 4 : n - 3
        for j = 4 : m - 3
            localmax(i, j) = max(max(R(i - 3 : i + 3, j - 3 : j + 3)));
        end
    end
    for i = 4 : n - 3
         for j = 4 : m - 3
             if (localmax(i, j) == R(i, j) && R(i, j) > threshold)
                 cnt = cnt + 1;
                 p_out(1, cnt) = i;
                 p_out(2, cnt) = j;
             end
         end
    end
    p = p_out;
    p = p(:, p(1, :) > S & p(1, :) < n - S & p(2, :) > S & p(2, :) < m - S);
    cnt = length(p(1, :));
    p_out = zeros(2, 100);
    p_out(:, 1 : cnt) = p;
    if(Flag == 0)
        cnt_com = cnt;
    else
        cnt_ori(Flag) = cnt;
    end
    
%     figure
%     imshow(I_in)
%     hold on
%     for i = 1 : cnt
%         x = p_out(1, i);
%         y = p_out(2, i);
%         plot(y, x, 'r*')
%         hold on
%     end
%     title('Harris')
end