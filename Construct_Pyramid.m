function I_out = Construct_Pyramid(I_in, level)
    [n, m] = size(I_in);
    I_out = zeros(n, m, level + 1);
    I_out(:, :, 1) = I_in;
    figure
    subplot(level + 1, 1, 1)
    imshow(I_out(:, :, 1), 'InitialMagnification', 'fit');
    hold on
    dx = [0, 0, 1, 1];
    dy = [0, 1, 0, 1];
    for id = 1 : level
        for i = 1 : floor(n / (2 ^ id))
            for j = 1 : floor(m / (2 ^ id))
%                 for k = 1 : 4
%                     I_out(i, j, id + 1) = I_out(i, j, id + 1) + ...
%                         I_out(2 * i - 1 + dx(k), 2 * j - 1 + dy(k), id);
%                 end
%                 I_out(i, j, id + 1) = I_out(i, j, id + 1) / 4;  %下采样时取平均值
                res = -1;
                for k = 1 : 4
                    res = max(res, I_out(2 * i - 1 + dx(k), 2 * j - 1 + dy(k), id));
                end
                I_out(i, j, id + 1) = res;    %下采样时取最大值
            end
        end
        subplot(level + 1, 1, id + 1)
        imshow(I_out(1 : floor(n / (2 ^ id)), 1 : floor(m / (2 ^ id)),...
           id + 1), 'InitialMagnification', 'fit');
        hold on
    end
end