%% Given a vector of data, the bungee function is trying to
%% to find when the data enters a stable state.
% @vec			input vector of data
% @spot	starting 	index of the stable state
% @threshold		threshold used to determine the starting point
function [spot,threshold] = bungee(vec)
  bound = length(vec);
  for i = 1:(bound-1)
    if vec(i) < 1
    	if vec(i) <= max(vec(i+1:bound))
      		break;
    	end
    end
  end
  spot = i;
  subvec = vec(i:bound);
  threshold = max(subvec);
end
