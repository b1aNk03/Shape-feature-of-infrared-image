function [link_out, res] = KM(map, N)
    global slack link ex_l ex_r vis_l vis_r mp eps;
%% initial
    eps = 1;
    mp = -map;
    link = zeros(1, N) - 1;
    ex_r = zeros(1, N);
    for i = 1 : N
        ex_l(i) = mp(i, 1);
        for j = 2 : N
            ex_l(i) = max(ex_l(i), mp(i, j));
        end
    end
%% main
    for i = 1 : N
        for j = 1 : N
            slack(j) = inf;
        end
        while 1
            vis_l = zeros(1, N);
            vis_r = zeros(1, N);
            if dfs(i, N)
                break;
            end
%             disp(['i = ' num2str(i)])
            d = inf;
            for j = 1 : N
                if ~vis_r(j)
                    d = min(d, slack(j));
                end
            end
            for j = 1 : N
                if vis_l(j)
                    ex_l(j) = ex_l(j) - d;
                end
                if vis_r(j)
                    ex_r(j) = ex_r(j) + d;
                else
                    slack(j) = slack(j) - d;
                end
            end
        end
    end
    res = 0;
    for i = 1 : N
        if link(i) ~= -1
            res = res + mp(link(i), i);
        end
    end
    res = -res;
    link_out = link;
end