function bool = dfs(u, N)
    global vis_l vis_r link slack mp ex_l ex_r eps;
    vis_l(u) = 1;
    for i = 1 : N
        if ~vis_r(i)
            if abs(ex_l(u) + ex_r(i) - mp(u, i)) < eps
                vis_r(i) = 1;
                if link(i) == -1 || dfs(link(i), N)
                    link(i) = u;
                    bool = 1;
                    return 
                end
            else
                slack(i) = min(slack(i), ex_l(u) + ex_r(i) - mp(u, i));
            end
        end
    end
    bool = 0;
end