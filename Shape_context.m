function Shape_context(I_ori_in, I_com_in, gra1, gra2)
%% var
    global cnt1 cnt2 ;
    N = 70;       %在轮廓上采样的点数
    k = 3;
    beta = 0.1;
    len = 256;
%% sampling on contour
    p1 = find_points(I_ori_in, 0);
    p2 = find_points(I_com_in, 1);
    p1 = Jitendra_sampling(I_ori_in, p1, N, k, cnt1);
    p2 = Jitendra_sampling(I_com_in, p2, N, k, cnt2);
%% construct histogram matrix
    Cs = Construct_histogram(p1, p2, N);
    CA = zeros(N, N);
    for i = 1 : N
        for j = 1 : N
            CA(i, j) = 0.5 * (1 - cos(gra1(i, j) - gra2(i, j)));
        end
    end
    C_final = (1 - beta) * Cs + beta * CA;
%% KM algorithm matching
    tic
    %[C, T] = KM(C_final, N);
    [C, T] = hungarian(C_final);
    toc
    th = 3 * T / N;
    nn = 0;
    for i = 1 : N
        x = C(i);
        y = i;
        if C_final(x, y) > th
            C(i) = -1;
            nn = nn + 1;
        end
    end
    I_final = zeros(len, len);
    for i = 1 : N
        x1 = p1(1, i);
        y1 = p1(2, i);
        x2 = p2(1, i);
        y2 = p2(2, i);
        I_final(x1, y1) = 1;
        I_final(x2, y2) = 1;
    end
    figure
    imshow(I_final)
    hold on
    wrong = 0;
    tot = 0;
    for i = 1 : N
        if C(i) == -1
            continue;
        end
        tot = tot + 1;
        x1 = p1(1, C(i));
        y1 = p1(2, C(i));
        x2 = p2(1, i);
        y2 = p2(2, i);
        if (x1 - x2) ^ 2 + (y1 - y2) ^ 2 > 8
            wrong = wrong + 1;
        end
        plot(y1, x1, 'r*')
        hold on
        plot(y2, x2, 'bo')
        hold on
        plot([y1, y2], [x1, x2]);
        hold on
    end
    disp(['accuracy = ' num2str((tot - wrong) / tot) '   ' num2str((N - nn) / N)])
end