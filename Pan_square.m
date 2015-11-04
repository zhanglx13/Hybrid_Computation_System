function [ X ] = Pan_square( A )
%% Proposed by Pan and Schreiber
 % [12] in this paper http://profdoc.um.ac.ir/articles/a/1040035.pdf
    X = transpose(A)/(norm(A,1)*norm(A,Inf));
end

