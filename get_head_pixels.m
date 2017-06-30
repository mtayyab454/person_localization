function head_pixels = get_head_pixels(hsm, X, Y)

    X = round(X);
    Y = round(Y);

    ind = sub2ind(size(hsm), Y, X);
    
    head_pixels = hsm(ind);
    
    head_pixels = head_pixels/4;
    head_pixels = ceil(head_pixels);
    head_pixels = max(head_pixels, 3);
end