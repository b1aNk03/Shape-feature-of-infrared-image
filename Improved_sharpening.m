function I_out = Improved_sharpening(I_in)
    size_window = 5;
    alpha = 0.5;
    K = 0.05;
    [n, m] = size(I_in);
    Lc = zeros(n, m);
    Lv = zeros(n, m);
    I_out = zeros(n, m);
    I_in = double(I_in);
    for i = 1 : n
        for j = 1 : m
            V = zeros(1, size_window * size_window);
%             cnt = 0;
%             avg = 0;         %局部均值
%             for dx = -2 : 2
%                 for dy = -2 : 2
%                     nx = i + dx;
%                     ny = j + dy;
%                     if (nx < 1 || nx > n || ny < 1 || ny > m)
%                         continue;
%                     else
%                         cnt = cnt + 1;
%                         avg = avg + I_in(nx, ny);
%                     end
%                 end
%             end               %求局部均值
%             avg = avg / cnt;
%             Lv(i, j) = sum(sum((I_in - avg) .^ 2)) / (n * m); %局部方差
            cnt = 0;
            for dx = -2 : 2
                for dy = -2 : 2
                    nx = i + dx;
                    ny = j + dy;
                    if (nx < 1 || nx > n || ny < 1 || ny > m)
                        continue;
                    else
                        cnt = cnt + 1;
                        V(cnt) = I_in(nx, ny);
                    end
                end
            end
            Lc(i, j) = length(unique(V)) - 1;                %局部复杂度
        end
    end
    Lv = stdfilt(I_in, ones(5));
    minLc = min(min(Lc));
    maxLc = max(max(Lc));
    minLv = min(min(Lv));
    maxLv = max(max(Lv));
    Lc = (Lc - minLc) / (maxLc - minLc);
    Lv = (Lv - minLv) / (maxLv - minLv);
    lambda = alpha * Lc + (1 - alpha) * Lv;
    avg = sum(sum(I_in)) / (n * m);
    for i = 1 : n
        for j = 1 : m
            for dx = -2 : 2
                for dy = -2 : 2
                    nx = i + dx;
                    ny = j + dy;
                    if (nx < 1 || nx > n || ny < 1 || ny > m)
                        continue;
                    else
                        I_out(i, j) = I_in(i, j) + K * lambda(i, j) * (I_in(i, j) - avg);
                        if I_out(i, j) > 255
                            I_out(i, j) = 255;
                        end
                    end
                end
            end
        end
    end
end