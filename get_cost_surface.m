function [cost_surface, pt_order, gf] = get_cost_surface(resp, pt_cost, gaussians, info, gf, talk)

    safe_margen = 5; %percent
    min_loop_count = 0;
    curr_min_ind = NaN;
    
    n = 100;
    area_th = 0.1;
    cost_surface = zeros(size(pt_cost));
    
    [pt_cost, pt_order] = sort(pt_cost, 'ascend');
    gaussians = gaussians(:,:,pt_order);
    info = info(pt_order, :);
    
    pt_valid = true(size(pt_order));
    pt_selected = false(size(pt_order));    
    count = 1;
    rects = info(:, [3 1 6 5]);
    
    difff = gf - resp;
    difff2 = difff.^2;
    
    if talk
        fprintf('Computing cost surface\n');
        fprintf(1,'%s\n\n', repmat('.',1, n));
    end    
    
    for i=1:length(pt_cost)
        
        if pt_valid(i) == 1
            rst = info(i, 1);
            ren = info(i, 2);
            cst = info(i, 3);
            cen = info(i, 4);
            rdim = info(i, 5);
            cdim = info(i, 6);

            gf(rst:ren, cst:cen) = gf(rst:ren, cst:cen) + gaussians(1:rdim, 1:cdim , i);
            difff(rst:ren, cst:cen) = gf(rst:ren, cst:cen) - resp(rst:ren, cst:cen);
            difff2(rst:ren, cst:cen) = difff(rst:ren, cst:cen).^2;
            cost_surface(count) = sum(sum(difff2));
            
            if i > 1 && cost_surface(count) > cost_surface(count-1)
                
                if min_loop_count == 0
                    curr_min_ind = i;
                end
                min_loop_count = min_loop_count + 1;
                
                if min_loop_count > min(round(safe_margen*curr_min_ind/100), 1000)
                    break;
                end
            else
                min_loop_count = 0;
                curr_min_ind = NaN;
            end
            
            count = count + 1;
            
            check_overlap = pt_valid & ~pt_selected;
            area = rectint(rects(check_overlap, :), rects(i, :));
            area = area./(rects(i, 3)*rects(i, 4));
            
            pt_valid(check_overlap) = area < area_th;
            pt_valid(i) = 1;
            pt_selected(i) = 1;
        end
        
        if talk && mod(i, floor(length(pt_cost)/n)) == 0
            fprintf(1,'\b.\n');
        end
    end
    
    cost_surface = cost_surface(1:count-1);
    pt_order = pt_order(pt_valid);
end