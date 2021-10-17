function p_out = Jitendra_sampling(I_in, p_in, N, k, cnt)
    dist2 = zeros(cnt, cnt);
    p_out = p_in;
%% randomize points
    randindex = randperm(cnt);
    p_in = p_in(:, randindex');
%% calculate distance matrix
    for i = 1 : cnt
        x1 = p_in(1, i);
        y1 = p_in(2, i);
        for j = 1 : cnt
            if i == j
                dist2(i, j) = inf;
                continue;
            end
            x2 = p_in(1, j);
            y2 = p_in(2, j);
            dist2(i, j) = (x1 - x2) ^ 2 + (y1 - y2) ^ 2;
        end
    end
%% main
    dist2 = dist2(1 : cnt, 1 : cnt);
    num_del = cnt - N;
    for id = 1 : num_del
        min_dist2 = min(min(dist2));
        flag = 0;
        for i = 1 : N
            for j = i : N
                if dist2(i, j) == min_dist2
                    pos = j;
                    flag = 1;
                    break;
                end
            end
            if flag == 1
                break;
            end
        end
        x = p_in(1, pos);
        y = p_in(2, pos);
        I_in(x, y) = 0;
        dist2(i(1, 1), :) = inf;
        dist2(:, i(1, 1)) = inf;
        p_out(:, pos) = [];
    end
%     figure
%     imshow(I_in)
end