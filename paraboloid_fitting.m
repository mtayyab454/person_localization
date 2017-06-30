function [P, type, rr, cc, Z] = paraboloid_fitting(resp)

    % resp = MxN, where N = number of different responses
    % X =    MxN, where N = number of different responses
    % Y =    MxN, where N = number of different responses    
    
    [x, y] = meshgrid(1:size(resp,2), 1:size(resp,1));
    x = x(:);
    y = y(:);
    A = [ones(length(x), 1), x, y, x.*y, x.^2, y.^2];
    c = reshape(resp, length(x), size(resp, 3));
    
    b = pinv(A)*c;
    type = stationary_type(b');
    
    z = A*b;
    
    [~, ind]  = max(z, [], 1);
    [rr, cc] = ind2sub([size(resp, 1), size(resp, 2)], ind);
    P = b';
    
    Z = reshape(z, size(resp));
%     if type == 1
%         a = P(1);
%         b = P(2);
%         c = P(3);
%         d = P(4);
%         e = P(5);
%         f = P(6);
% 
%         X = (c*d - 2*b*f)/(- d^2 + 4*e*f); % stationary point X coordinate
%         Y = (b*d - 2*c*e)/(- d^2 + 4*e*f); % stationary point Y coordinate
% 
%         dx = b + d*Y + 2*e*X;
%         dy = c + d*X + 2*f*Y;    
%     end
end