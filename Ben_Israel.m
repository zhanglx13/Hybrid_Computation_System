%% Approximation of the inverse of matrix A
% @A		input matrix A
% @X		output approximation of inverse of A
function [ X ] = Ben_Israel( A )
%% Proposed by Ben-Israel and Greville
 % [2] of this paper http://profdoc.um.ac.ir/articles/a/1040035.pdf
  X = transpose(A)/(norm(A,2)^2);
end

