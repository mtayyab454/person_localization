function [X, Y] = get_candidate_locs(response_mat, hsm, roi, min_hs,  rsize, th)

    step1 = 3;
    step2 = 2;

    pad = ceil(rsize*max(hsm(:)));
    padded_resp = padarray(response_mat, [pad, pad], 0, 'both');
    padded_hsm = padarray(hsm, [pad, pad], 0, 'both');
    padded_roi = padarray(roi, [pad, pad], 0, 'both');    
    
    [x, y] = meshgrid(pad+1 :step1: (size(padded_resp,2)-pad), pad+1 :step1: (size(padded_resp,1)-pad));
    response_vec = NaN(1, numel(x));
    hsvec = padded_hsm(:, pad+1);

    n = 100;
    fprintf('Fitting parabolas: \n');
    fprintf(1,'%s\n\n', repmat('.',1, n));
    
    tic;
    parfor j=1:numel(x)
        cu_x = x(j);
        cu_y = y(j);
        chs = hsvec(cu_y);
        
        if chs > min_hs && padded_roi(cu_y, cu_x) == 1 && padded_resp(cu_y, cu_x) > th
            cx = cu_x - (chs*rsize/2);
            cy = cu_y - (chs*rsize/2);
            rect = round([cx, cy, chs*rsize, chs*rsize]);

            %%%%% Extract Patch %%%%%%
            cresp = imcrop(padded_resp, rect);
            response_vec(j) = is_peak(cresp);
        end
        
        if rand < n/numel(x)
            fprintf(1,'\b.\n');
        end        
    end
    
    response_vec(isnan(response_vec)) = 0;
    r = reshape(response_vec, size(x));
    rr = imresize(r, size(response_mat));

    se = strel('disk', 1);
    rr = double(rr > 0.5);
    rr = imdilate(uint8(rr*255), se);
    
    [x, y] = meshgrid(1:step2:size(response_mat,2), 1:step2:size(response_mat,1));
    ind = sub2ind(size(response_mat), y, x);
    valid_mask_roi = roi(ind);
    peak_mask = rr > 128;
    valid_mask_peak = peak_mask(ind);
    valid_mask = valid_mask_roi & valid_mask_peak;
    
    X = x(valid_mask);
    Y = y(valid_mask);

%     imagesc(rr > 0.5);
%     hold on;
%     scatter(X, Y, 'r.');
end