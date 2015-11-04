%% After 1000 experiments of matrixDim by matrixDim matrices are done,
%% process the data and draw a figure to show the number of iterations
%% to be stable and the error threshold.
%% The result of using 5, 10, 15,20 bits and digital computation are
%% drawn. The averge of each line is computed. For those experiment
%% that does not converge, the sopt is empty.
function dataProcess(matrixDim)
  	
	display(['Processing data matrix_', num2str(matrixDim),'.mat....']);
	data_filename = ['/expResult/data/matrix_', num2str(matrixDim),'.mat'];
	S = load([pwd data_filename]);
	spotM = S.spotM;
	minBits = S.minBits;
	stopCriterion = S.stopCriterion; 
	h = figure('visible', 'off');
	hold on;
	% compute the average of each line (0 does not included)
	mean5 = mean(spotM(1,find(spotM(1,:))));
	mean10 = mean(spotM(2,find(spotM(2,:))));
	mean15 = mean(spotM(3,find(spotM(3,:))));
	mean20 = mean(spotM(4,find(spotM(4,:))));
	mean_digit = mean(spotM(5,find(spotM(5,:))));
	spotM(spotM == 0) = NaN;	% Convert 0 to NaN to skip some point
	x = linspace(1,1000,1000);
	fig_digit = plot(spotM(5,:));
%	fig_digit = scatter(x,spotM(5,:),'.');
	fig5 = plot(spotM(1,:));
%	fig5 = scatter(x,spotM(1,:),'.');
	fig10 = plot(spotM(2,:));
%	fig10 = scatter(x,spotM(2,:),'.');
	fig15 = plot(spotM(3,:));
%	fig15 = scatter(x,spotM(3,:),'.');
	fig20 = plot(spotM(4,:));
%	fig20 = scatter(x,spotM(4,:),'.');
	
	%%------------------------------%%
	%% Configure the plot properties
	%%------------------------------%%
	% Figure properties
	h.Position = [100,100,1000,800];	% figure position and size [left bottom width height]
	% Labels
	xlabel('Experiment index')
	ylabel('#iterations to converge')
	% chart line
	line_width = 1.5;
	fig5.LineWidth = line_width;
	fig5.DisplayName = ['05 bits --- ', num2str(mean5), ' iterations'];
	fig10.LineWidth = line_width;
	fig10.DisplayName = ['10 bits --- ', num2str(mean10), ' iterations'];
	fig15.LineWidth = line_width;
	fig15.DisplayName = ['15 bits --- ', num2str(mean15), ' iterations'];
	fig20.LineWidth = line_width;
	fig20.DisplayName = ['20 bits --- ', num2str(mean20), ' iterations'];
	fig_digit.LineWidth = line_width;
	fig_digit.DisplayName = ['Digit --- ', num2str(mean_digit), ' iterations'];
	% Legend
	leg = legend('show');
	leg.FontSize = 09;
	%%--------------------------%%
	%% Save and close the figure
	%%--------------------------%%
	fig_name = ['/expResult/data/matrix_', int2str(matrixDim)];
	saveas(h, [pwd fig_name, '.fig']);
	saveas(h, [pwd fig_name, '.png']);
	close(h);
	display('Complete!');
	display('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
end
