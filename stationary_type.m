function type = stationary_type(p)

	% p = [N x 6];

    type = NaN(size(p, 1), 1);
    d = p(:, 4);
    e = p(:, 5);
    f = p(:, 6);  

    dxx = 2*e;
    dyy = 2*f;    
    dxy = d;

    f1 = dxx > 0 & (dxx.*dyy - dxy.*dxy) > 0;
    f2 = dxx < 0 & (dxx.*dyy - dxy.*dxy) > 0;
    f3 = (dxx.*dyy - dxy.*dxy) < 0;
    
    type(f1) = -1;
    type(f2) = 1;
    type(f3) = 0;    

end