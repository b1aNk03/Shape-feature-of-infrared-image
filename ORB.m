function D_out = ORB(Points, I, Flag, s)
    global cnt_ori cnt_com N;
    global check_theta check_M00 check_M10 check_M01;
    [n, m] = size(I);
    if (Flag == 0)
        cnt = cnt_com;
    else
        cnt = cnt_ori(Flag);
        n = n / (2 ^ (Flag - 1));
        m = m / (2 ^ (Flag - 1));
    end
    D_out = zeros(cnt, N);
    for i = 1 : cnt
        x = Points(1, i);
        y = Points(2, i);
        M00 = calc_moment(x, y, I, 0, 0);
        M10 = calc_moment(x, y, I, 1, 0);
        M01 = calc_moment(x, y, I, 0, 1);  %计算矩，输入中心点坐标，图像，是否需要乘x或y，质心框大小
        Cx = M10 / M00;
        Cy = M01 / M00;                                %矩的质心
        theta = atan2(Cy, Cx);                         %向量旋转的角度，正值逆时针，负值顺时针
        check_theta(Flag + 1, i) = theta;
        check_M00(Flag + 1, i) = M00;
        check_M10(Flag + 1, i) = M10;
        check_M01(Flag + 1, i) = M01;
        
        p = Points;

        %H = fspecial('gaussian', [K K], 2);
        graph = I;
        %graph = imfilter(graph, H, 'replicate');

        new_s = rotate_vec(s, -theta, N);
        %Check_s(new_s, 5)

        
        %for j = 1 : cnt
            p1 = round([x; y] + [new_s(1, :); new_s(3, :)]);
            p2 = round([x; y] + [new_s(2, :); new_s(4, :)]);

            for k = 1 : N
                if (graph(p1(1, k), p1(2, k)) < graph(p2(1, k), p2(2, k))) 
                    D_out(i, k) = 1;
                else
                    D_out(i, k) = 0;
                end
            end
        %end
    end
end