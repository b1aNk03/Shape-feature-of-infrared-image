function Check_s(s, N)
    figure
    for i = 1 : N
       plot(s(3 : 4, i), s(1 : 2, i));    
       hold on;
    end
end