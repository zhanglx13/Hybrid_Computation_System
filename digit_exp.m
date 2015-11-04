%% Combine the experiments using Pan and Ben
%% as the initial value
% @A			target matrix to be inverted
% @I			identity matrix
% @init			flag indicating which initial value to use. 0 for Ben and 1 for Pan
% @norm_E_vec		output vector of norm of the error matrix of each iteration
function [ norm_E_vec ] = digit_exp(A,I, init)
	if init == 0
		% Using Ben as initial value
		X = Ben_Israel( A );
	else
		% Using Pan as initial value
		X = Pan( A );
	end
	E = I - A*X; 				% Error used for stopping criterion
	iteration = 0; 				% Conuter of #iterations
	for i = 1:150
		iteration = iteration +1; 	% One more iteration
        	X = X*(2*I - A*X); 		% Update X
        	E = I - A*X; 			% Update error
		norm_E_vec(i) = norm(E);
    	end
end




	
