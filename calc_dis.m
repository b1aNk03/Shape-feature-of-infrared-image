function mat = calc_dis(p_in, N)
    mat = zeros(N, 60);
    dist = zeros(N, N);
    theta = zeros(N, N);
%     avg = 0;
    for i = 1 : N
        x1 = p_in(1, i);
        y1 = p_in(2, i);
        for j = 1 : N
            if i == j
                dist(i, j) = inf;
                theta(i, j) = 0;
                continue;
            end
            x2 = p_in(1, j);
            y2 = p_in(2, j);
            dist(i, j) = sqrt((x1 - x2) ^ 2 + (y1 - y2) ^ 2);
            theta(i, j) = atan2((y2 - y1), (x2 - x1));
%             avg = avg + dist(i, j);
        end
    end
%     avg = avg / (N ^ 2 - N);
%     dist = log10(dist / avg);
    dist = log10(dist);
    N_p = N;
    for i = 1 : N
        for j = 1 : N
            if i == j
                continue;
            end
            theta_index = get_theta_index(theta(i, j));
            if dist(i, j) <= 0.125
                dist_index = 0;
            elseif dist(i, j) > 0.125 || dist(i, j) <= 0.25
                dist_index = 1;
            elseif dist(i, j) > 0.25 || dist(i, j) <= 0.5
                dist_index = 2;
            elseif dist(i, j) > 0.5 || dist(i, j) <= 1.0
                dist_index = 3;
            elseif dist(i, j) > 1.0 || dist(i, j) <= 2.0
                dist_index = 4;
            else
                N_p = N_p - 1;
                continue;
            end
            mat(i, dist_index * 12 + theta_index) = mat(i, dist_index * 12 + theta_index) + 1;
        end
    end
end