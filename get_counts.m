function [N, X, Y, cost_surface, curr_pt_cost, curr_pt_order, gf_modified] = get_counts(resp, hsm, x, y, min_val)

    talk = 1;
    max_val_vec = ones(size(x)) - min_val;
    min_val_vec = zeros(size(x));
    gf_org = ones(size(hsm))*min_val;

    [gaussians, info] = get_gaussians(hsm, round(x), round(y), min_val_vec, max_val_vec);
    pt_cost = get_costs(resp, gaussians, info, min_val, talk);
    [cost_surface, pt_order, gf_modified] = get_cost_surface(resp, pt_cost, gaussians, info, gf_org, talk); 
    
    [~, n] = min(cost_surface);

    curr_pt_order = pt_order(1:n);
    curr_pt_cost = pt_cost(curr_pt_order);
    X = x(curr_pt_order);
    Y = y(curr_pt_order);
    
    N = n;
end