%% run experiments of different matrices with different sizes
%% Each size of matrices will run 1000 experiments followed
%% by the data process. 
function run_exp()
  	for matrixDim = 80:1:150
		MatrixInverseIterative_rand(matrixDim,1000);
		dataProcess(matrixDim);
    	end
end
