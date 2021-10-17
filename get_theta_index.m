function theta_index = get_theta_index(theta)
    if theta > 0
        theta_index = ceil(6 * theta / pi);
    else
        theta_index = 13 + floor(6 * theta / pi);
    end
end