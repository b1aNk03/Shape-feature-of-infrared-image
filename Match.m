function Match(Points1, Points2, I1, I2, D1, D2, id, Flag)       %D1的长度小于等于D2，所以用D1去匹配D2
    global cnt_ori cnt_com row_ori column_ori row_com column_com;
    if (Flag == 1)
        cnt1 = cnt_ori(id);
        cnt2 = cnt_com;
        d1 = D1(1 : cnt1, :, id);
        d2 = D2;
    else
        cnt1 = cnt_com;
        cnt2 = cnt_ori(id);
        d1 = D1;
        d2 = D2(1 : cnt1, :, id);
    end
    
    V = ones(1, cnt2);
    res(1, 100) = struct('weight', [], 'first', [], 'second', []);
    for i = 1 : cnt1
        res(i).weight = -1;
        res(i).first = i;
        for j = 1 : cnt2
            weight = sum(~xor(d1(i, :), d2(j, :)));
            if (weight > res(i).weight && V(j) == 1)
                res(i).second = j;
                res(i).weight = weight;
            end
        end
        V(res(i).second) = 0;
    end
    
    row_ori = row_ori / (2 ^ (id - 1));
    column_ori = column_ori / (2 ^ (id - 1));
    final = ones(max(row_ori, row_com), column_ori + column_com + 40);
    final(1 : row_ori, 1 : column_ori) = I1;
    final(1 : row_com, column_ori + 41 : column_ori + 40 + column_com) = I2; %将两幅图显示在同一张上
    figure
%     imshow(uint8(final))
    imshow(final)
    hold on
    for i = 1 : cnt1
        pos1 = res(i).first;
        pos2 = res(i).second;
        disp([num2str(pos1) '->' num2str(pos2) '  weight=' num2str(res(i).weight)])
        x1 = Points1(1, pos1);
        y1 = Points1(2, pos1);
        x2 = Points2(1, pos2);
        y2 = Points2(2, pos2) + 41 + column_ori;
        plot(y1, x1, 'r*')
        hold on
        plot(y2, x2, 'b*')
        hold on
        plot([y1, y2], [x1, x2]);
        hold on
    end
end