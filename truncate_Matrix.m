function [ X_new ] = truncate_Matrix( X, n )
%truncate: convert each element in X to be of a precision of n bits.
    X_new = X;  % Preallocate X_new for speed.
    d = size(X);
    for row = 1:d(1)
        for col = 1:d(2)
            X_new(row,col) = truncate_value(X(row,col), n);
        end
    end

end

