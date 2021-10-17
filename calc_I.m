function I = calc_I(graph, window, n, m, len)
   I = zeros(n, m);
    for i = 1 + fix(len / 2) : n - fix(len / 2)
        for j = 1 + fix(len / 2) : m - fix(len / 2)
            I(i, j) = sum(sum(graph(i - fix(len / 2) : i + fix(len / 2), j - fix(len / 2) : j + fix(len / 2)) .* window));
        end
    end
end