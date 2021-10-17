function p = find_points(I_in, Flag)
    global cnt1 cnt2;
    cnt = 0;
    [n, m] = size(I_in);
    p = zeros(2, 400);
    for i = 1 : n
        for j = 1 : m
            if I_in(i, j) == 1
                cnt = cnt + 1;
                p(1, cnt) = i;
                p(2, cnt) = j;
            end
        end
    end
    if Flag == 0
        cnt1 = cnt;
    else
        cnt2 = cnt;
    end
end