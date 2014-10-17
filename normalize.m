function [N] = normalize(X)    
    maxval = max(max(X));
    N = X*(1/maxval);
end