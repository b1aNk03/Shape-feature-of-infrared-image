function M = calc_moment(x, y, I, Flag_x, Flag_y)
    M = 0;
    %I = double(I);
    for dx = -2 : 2
        for dy = -2 : 2
            nx = x + dx;
            ny = y + dy;
            if sqrt(dx ^ 2 + dy ^ 2) <= 2.0
            %M = M + dx(i) ^ Flag_x * dy(i) ^ Flag_y * I(nx, ny);
                M = M + (-dx) ^ Flag_y * dy ^ Flag_x * I(nx, ny);
            end
        end
    end
end