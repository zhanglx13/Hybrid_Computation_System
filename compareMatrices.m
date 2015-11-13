%% Now the expResult/data folder contains the result of matrices 10 --- 94
%% This function will compare some parameters from matrices with different sizes
function compareMatrices()
  ave_spotM = zeros(5,85);	% [5 bits, 10 bits, 15 bits, 20 bits, digit]
  ave_minBits = zeros(1,85);	% minbit for each size of matrices
  ave_epsilon = zeros(1,85);	% stopping criterion for each size of matrices
for matrixDim = 10:1:94
	display(['Processing data matrix_', num2str(matrixDim),'.mat....']);
	data_filename = ['/expResult/data/matrix_', num2str(matrixDim),'.mat'];
	S = load([pwd data_filename]);
	spotM = S.spotM;
	minBits = S.minBits;
	stopCriterion = S.stopCriterion; 
	% compute the average of each line (0 does not included)
	ave_spotM(1, matrixDim-9) = mean(spotM(1,find(spotM(1,:))));
	ave_spotM(2, matrixDim-9) = mean(spotM(2,find(spotM(2,:))));
	ave_spotM(3, matrixDim-9) = mean(spotM(3,find(spotM(3,:))));
	ave_spotM(4, matrixDim-9) = mean(spotM(4,find(spotM(4,:))));
	ave_spotM(5, matrixDim-9) = mean(spotM(5,find(spotM(5,:))));
	% Compute the average of minimum bits
	ave_minBits(matrixDim-9) = mean(minBits(:));
	% Compute the average of stopping criterion
	ave_epsilon(matrixDim-9) = mean(stopCriterion(stopCriterion<1));
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%% There is a bug in the program computing the stopping criterion  %%
	%% In the 662 experiment of matrix 10, the figure looks good,      %% 
	%% but the stopping criterion is said to be 46, which is obviously %%
	%% wrong. This issue should be taken care of in the future.        %%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
end % end for matrixDim = 10:1:94
	%% plot the number of iterations to be stable
	h1 = figure();
	hold on;
	x = linspace(10,94,85);
	fig_digit = plot(x, ave_spotM(5,:));
	fig05 = plot(x, ave_spotM(1,:));
	fig10 = plot(x, ave_spotM(2,:));
	fig15 = plot(x, ave_spotM(3,:));
	fig20 = plot(x, ave_spotM(4,:));
	%%------------------------------%%
	%% Configure the plot properties
	%%------------------------------%%
	% Figure properties
%	h1.Position = [100,100,1000,800];	% figure position and size [left bottom width height]
	% Labels
	xlabel('Matrix dimension')
	ylabel('Average #iterations to converge')
	% chart line
	line_width = 1.5;
	fig05.LineWidth = line_width;
	fig05.DisplayName = '05 bits';
	fig10.LineWidth = line_width;
	fig10.DisplayName = '10 bits';
	fig15.LineWidth = line_width;
	fig15.DisplayName = '15 bits';
	fig20.LineWidth = line_width;
	fig20.DisplayName = '20 bits';
	fig_digit.LineWidth = line_width;
	fig_digit.DisplayName = 'Digit';
	% Legend
	leg = legend('show');
	leg.FontSize = 09;
	%%--------------------------%%
	%% Save and close the figure
	%%--------------------------%%
	fig_name = ['/expResult/matrixCompare'];
	saveas(h1, [pwd fig_name, '.fig']);
	saveas(h1, [pwd fig_name, '.png']);
%	close(h);
	%% Plot the minimum bits to guarantee convergence 
	h2 = figure();
	fig_minbits = plot(x, ave_minBits(:));
	% Labels
	xlabel('Matrix dimension')
	ylabel('Minimum bits to converge')
	% chart line
	fig_minbits.LineWidth = line_width;
	%% Plot the stopping criterion
	h3 = figure();
	fig_sc = plot(x, ave_epsilon(:));
	% Labels
	xlabel('Matrix dimension')
	ylabel('Stopping criterion')
%	display('Complete!');
%	display('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');


end % end function compareMatrices()
