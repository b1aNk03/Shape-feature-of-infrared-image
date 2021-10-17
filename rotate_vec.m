function s_out = rotate_vec(s_in, theta, N)
    s_out = zeros(4, N);
    for i = 1 : N
        for j = 1 : 2
            x0 = s_in(j, i);
            y0 = s_in(j + 2, i);
            %if(theta < 0)
%                 x1 = x0 * cos(theta) - y0 * sin(theta);
%                 y1 = x0 * sin(theta) + y0 * cos(theta);
                y1 = y0 * cos(theta) - x0 * sin(theta);
                x1 = y0 * sin(theta) + x0 * cos(theta);
            %else
%                 x1 = x0 * cos(theta) + y0 * sin(theta);
%                 y1 = -x0 * sin(theta) + y0 * cos(theta); 
            %    y1 = y0 * cos(theta) + x0 * sin(theta);
            %    x1 = -y0 * sin(theta) + x0 * cos(theta); 
            %end
            s_out(j, i) = x1;
            s_out(j + 2, i) = y1;
        end
    end
end