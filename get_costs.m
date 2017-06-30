function [cost] = get_costs(resp, gaussians, info, min_val, talk)
    n = 100;
    
    num_pts = size(gaussians, 3);
    cost = NaN(1, num_pts);
    diff = (resp - min_val).^2;
    sum_diff = sum(sum(diff));

    if talk
        fprintf('Computing costs\n');
        fprintf(1,'%s\n\n', repmat('.',1, n));
    end
    for i=1:size(gaussians, 3)

        rst = info(i, 1);
        ren = info(i, 2);
        cst = info(i, 3);
        cen = info(i, 4);
        rdim = info(i, 5);
        cdim = info(i, 6);

        temp = (min_val + gaussians(1:rdim, 1:cdim , i) - resp(rst:ren, cst:cen)).^2;
        c1 = sum_diff - sum(sum(diff(rst:ren, cst:cen))) + sum(sum(temp));

        cost(i) = c1;

        if talk && mod(i, floor(size(gaussians, 3)/n)) == 0
            fprintf(1,'\b.\n');
        end
    end
end