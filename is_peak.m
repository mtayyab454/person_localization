function [flag, P, r, c, z] = is_peak(resp)
    th = 1;

    m = round(size(resp, 1)/2);
    [P, type, r, c, z] = paraboloid_fitting(resp);
    
    d = pdist([r, c; m, m], 'euclidean')/(2*m);
    flag = d < th & type == 1;
end