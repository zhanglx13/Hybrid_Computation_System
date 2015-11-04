%% Run expNum of experiments of randomly generated matrixDim by matrixDim matrices.
%% For each experiment, run 1 to 20 bits to find the minimum number of bits to converge
%% and Ben and Pan for comparision. Draw a figure of the convergence, which also include
%% the error threshold.
function [] = MatrixInverseIterative_rand(matrixDim, expNum)
	reset(RandStream.getGlobalStream,sum(100*clock));	% Set the seed of rng
	% spotM is the matrix to store the spot of analog5, analog10, analog15, analog20, and digit
	spotM = zeros(5, expNum);	% Number of iterations need to be stable
	minBits = zeros(1,expNum);	% Minimum number of bits to guarantee convergence
	stopCriterion = zeros(1, expNum);	% Criterion used to "stopping" the algorithm
	% Displaying msg
	display('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
	display(['Performing ', int2str(expNum), ' experiments of ', int2str(matrixDim), 'x', int2str(matrixDim), ' matrices']);
	display(' ');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% start expNum experiments, each of which deals a single matrix  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
for exp_iter = 1:expNum
	%%-----------------------------------------------------------%%
  	%% Print some msg to get track of the progress of the program
  	%%-----------------------------------------------------------%%
	if mod(exp_iter,50) == 1
    		upperbound = min([exp_iter+49, expNum]);
		if upperbound == exp_iter
	  		display(['     Running experiment ', int2str(exp_iter), '......']);
	  	else
  	    		display(['     Running experiments ', int2str(exp_iter), ' to ', int2str(upperbound), '......']);
		end
	end
  	A = rand(matrixDim,matrixDim); % input matrix to be inverted
	X_orig = inv(A);
	I = eye(matrixDim); 		% Identity matrix
	
	h = figure('visible', 'off');
	hold on;
	%%--------------------------------------------------------------------------%%
	%% The following experiments start with the result from the analog circuitry
	%%--------------------------------------------------------------------------%%
	spot = 0;
	threshold = 0;
	for precision = 20:-1:1		% Experiment on different number of bits
		isConverge = 1;		% 1 stands for "The algorithm converges" and 0 stands for "The algorithm does not"
		X = truncate_Matrix(X_orig, precision);				
		E = I - A*X; 		% Error used for stopping criterion
		%init_norm = norm(E);	% Initial norm used to rule out some lines
		iteration = 0; 		% Conuter of #iterations
		fig_name = strcat(int2str(precision), ' bits');
		for i = 1:150
			iteration = iteration +1; 	% One more iteration
        		X = X*(2*I - A*X);		% Update X
        		E = I - A*X; 			% Update error
			norm_E_vec(i) = norm(E);
			if norm(E) > 100
				isConverge = 0;
			  	break;
			end
    		end

		if (isConverge == 1)% && (init_norm <= 10)
			[spot, threshold] = bungee(norm_E_vec);
			stopCriterion(exp_iter) = max([stopCriterion(exp_iter), threshold]);
			if mod(precision,3) == 0
				fig_name = [fig_name, ' --- ', int2str(spot), ' iterations'];
				plot(norm_E_vec, 'DisplayName', fig_name, 'LineWidth',1.5);
			end
			if mod(precision, 5) == 0
				spotM(precision/5, exp_iter) = spot;
			end
		else
		  	% The minimum number of bits to garantee the algorithm
			% to convergen should be the previous precision
			minBits(exp_iter) = precision + 1;
			break;
		end
	end
	
	%%-------------------------------------------------------%%
	%% The following experiments start with X0 from the paper
	%%-------------------------------------------------------%%
	norm_E_vec = digit_exp(A, I, 0);	% Experiment of Ben
	spot_ben = bungee(norm_E_vec);
	fig_name = ['Ben --- ', int2str(spot_ben), ' iterations'];
	fig_ben = plot(norm_E_vec, '--o', 'DisplayName', fig_name);

	norm_E_vec = digit_exp(A, I, 1);	% Experiment of Pan
	spot_pan = bungee(norm_E_vec);
	fig_name = ['Pan --- ', int2str(spot_pan), ' iterations'];
	fig_pan = plot(norm_E_vec, '--s','DisplayName', fig_name);

	spotM(5, exp_iter) = min([spot_ben, spot_pan]);
	%%------------------------------%%
	%% Configure the plot properties
	%%------------------------------%%
	% Figure properties
	h.Position = [100,100,1000,800];	% figure position and size [left bottom width height]
	% Labels
	xlabel('#iterations')
	ylabel('norm(I-AX)')
	% axis
	axis auto	% Automatically select axis limits
	ax = gca;
	ax.YScale = 'log';	% Set the Y axis scale to log
	ax.YGrid = 'on';	% Turn on Y axis grid lines
	ax.XLim = [0,spot_pan+10];	% Set the limit of the X axis to be 0 --- 100
	ax.YLim = [0,5];
	% chart line
	line_width = 1.5;
	fig_ben.LineWidth = line_width;
	fig_pan.LineWidth = fig_ben.LineWidth;
	% reference line: stopping criterion
	%display(num2str(stopCriterion(exp_iter)));
	rline = refline([0, stopCriterion(exp_iter)]);
	rline.LineWidth = 1.5;
	rline.Color = 'k';
	rline.DisplayName = ['stopping criterion', char(10), num2str(stopCriterion(exp_iter))];
	% Legend
	leg = legend('show');
	leg.FontSize = 09;
	%%--------------------------%%
	%% Save and close the figure
	%%--------------------------%%
	fig_name = ['/expResult/figure/matrix_',int2str(matrixDim), '/matrix', int2str(matrixDim),'_', int2str(exp_iter)];
	saveas(h, [pwd fig_name, '.fig']);
	saveas(h, [pwd fig_name, '.png']);
	h.Visible = 'on';
	close(h)
end % end expNum number of matrices of the same Dim

%%%%%%%%%%%%%%%%%%%
%% Save the data %%
%%%%%%%%%%%%%%%%%%%
	data_name = ['/expResult/data/matrix_', int2str(matrixDim), '.mat'];
	save([pwd data_name], 'spotM', 'minBits', 'stopCriterion')

	display(' ');
	display(['Finish ', int2str(expNum), ' experiments of ', int2str(matrixDim), 'x', int2str(matrixDim), ' matrices']);
	

end

