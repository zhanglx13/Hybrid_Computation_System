function [ X ] = Pan( A )
%% Proposed by Pan and Schreiber
 % [12] in this paper http://profdoc.um.ac.ir/articles/a/1040035.pdf
    [U,S,V] = svd(A);
	sigma = diag(S);
	sig_max = max(sigma);
	sig_min = min(sigma);
	X = 2*transpose(A)/(sig_max^2 + sig_min^2);

end

