function p_out = FAST(I_in, threshold, Flag)
    graph = double(I_in);
    [n, m] = size(graph);
    if (Flag ~= 0)
        n = n / (2 ^ (Flag - 1));
        m = m / (2 ^ (Flag - 1));
    end
    V = zeros(n, m);
    p_out = zeros(2, 200);
    global cnt_ori cnt_com S;
%% fast algorithm
    %      1, 5, 9, 13, 2,  3,  4, 6, 7, 8, 10, 11, 12, 14, 15 16
    dx = [-3, 0, 3, 0, -3, -2, -1, 1, 2, 3,  3,  2,  1, -1, -2, -3];
    dy = [0,  3, 0, -3, 1,  2,  3, 3, 2, 1, -1, -2, -3, -3, -2, -1];
    for i = 4 : n - 3
        for j = 4 : m - 3
            num = 0;
            res = 0;
            for k = 1 : 4
                delta = abs(graph(i + dx(k), j + dy(k)) - graph(i, j));
                res = res + delta;
                if delta >= threshold
                    num = num + 1;
                end
            end
            if num < 3
                V(i, j) = 0;
                continue;
            end
            for k = 5 : length(dx)
                delta = abs(graph(i + dx(k), j + dy(k)) - graph(i, j));
                res = res + delta;
                if delta > threshold
                    num = num + 1;
                end
            end
            if num < 12
                V(i, j) = 0;
                continue;
            end
            V(i, j) = res;
        end
    end
%% non-maximum suppression
    % dxx = [-1, -1, -1, 0, 0, 1, 1, 1];
    % dyy = [-1, 0, 1, -1, 1, -1, 0, 1];
    dxx = [-2, -2, -2, -2, -2, -1, -1, -1, -1, -1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2];
    dyy = [-2, -1, 0, 1, 2, -2, -1, 0, 1, 2, -2, -1, 1, 2, -2, -1, 0, 1, 2, -2, -1, 0, 1, 2];
    cnt = 0;
    for i = 6 : n - 5
        for j = 6 : m - 5
            flag = false;
            for k = 1 : length(dxx)
                if (V(i, j) <= V(i + dxx(k), j + dyy(k)))
                    flag = true;
                    break;
                end
            end
            if (~flag)
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
%     title('FAST')
end