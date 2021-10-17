function Cs = Construct_histogram(p1, p2, N)
    Cs = zeros(N, N);
%% main
    mat_g = calc_dis(p1, N);
    mat_h = calc_dis(p2, N);
%     for i = 1 : N
%         for j = 1 : N
%             Cs(i, j) = inf;
%         end
%     end
    for i = 1 : N
        for j = 1 : N
            res = 0;
            for k = 1 : 60
                res = res + (mat_g(i, k) - mat_h(j, k)) ^ 2 / (mat_g(i, k) + mat_h(j, k) + 0.000001);
            end
            Cs(i, j) = res / 2;
        end
    end
end