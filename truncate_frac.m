% @frac			input fractional number 
% @bits_left		number of bits to represent the fractional number
% @frac_new		output fractional number	
function [ frac_new ] = truncate_frac( frac, bits_left )
	frac_new = 0;
	for i = 1:bits_left
		if frac_new + (0.5)^i < frac
			frac_new = frac_new + (0.5)^i;
		end
	end
end

