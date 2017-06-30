% rmpath(genpath('/home/tayyab/codes/Custom_Matlab_Codes'));

ccc;

min_hs = 2;
rsize = 1.5;
th = 0.3;
min_val = 0.22;

data_path = 'data/';

files = dir([data_path '*.jpg']);

for i=1:length(files)
    im_name = files(i).name;
    im = imread([data_path im_name]);
    load([data_path im_name(1:end-4) '_response.mat']);
    load([data_path im_name(1:end-4) '_hsm.mat']);
    load([data_path im_name(1:end-4) '_roi.mat']);
    
    if exist([data_path im_name(1:end-4) '_ann.mat'], 'file')
        load([data_path im_name(1:end-4) '_ann.mat']);
        ann_flag = 1;
        ann_pts = annPoints;
    else
        ann_flag = 0;
    end
    
    tic;
    if exist([data_path im_name(1:end-4) '_candidate_locs.mat'], 'file')
        load([data_path im_name(1:end-4) '_candidate_locs.mat']);
    else
        [cX, cY] = get_candidate_locs(response_mat, hsm, roi, min_hs,  rsize, th);
        save([data_path im_name(1:end-4) '_candidate_locs.mat'], 'cX', 'cY', 'min_hs',  'rsize', 'th');
    end
    
    [N, X, Y, cost_surface1] = get_counts(response_mat, hsm, cX, cY, min_val);    
    tt = toc;
    
    pixel_head_size = get_head_pixels(hsm, X, Y);
    im_disp = insertShape(im, 'FilledCircle', [X, Y, pixel_head_size.*ones(N, 1)], 'Color', 'Red', 'Opacity', 1);
%     figure; imshow(im_disp);
    imwrite(im_disp, ['results/' im_name(1:end-4) '.jpg']);

    fprintf('\n\nImage: %s\n', im_name);
    fprintf('Estimated Count: %d\n', N);
    if ann_flag
        fprintf('Ground Truth: %d\n', length(ann_pts));
        difff = abs(length(ann_pts)-N);
        accuracy = (1 - difff/length(ann_pts))*100;
        fprintf('Accuracy: %0.2f\n', accuracy);
    end
        
    save(['results/' im_name(1:end-4) '_localization.mat'], 'X', 'Y', 'N', 'tt');
    
end