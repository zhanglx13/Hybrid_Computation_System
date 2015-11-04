% @val		a floating point number to be truncated
% @n 		number of bits of the truncated value
% @val_new	truncated floating point value
function [ val_new ] = truncate_value( val, n )
% This function truncate the input value to 
% preserve n bits in the binary representation
	[ sign, int, frac ] = seperate( val );
	if sign == 0		% When the input is 0
		val_new = 0;
	else				% When the input is positive or negative
		int_b = dec2bin(int);
		if numel(int_b) >= n	% When the integer part is big enough, 
					% no need to consider the fractional part
			val_new = truncate_int(int_b, n);
		else
			bits_left = n - numel(int_b);		% bits left for the fractional part should be at least 1
			val_new = int + truncate_frac(frac, bits_left);
		end	
	end
	if sign == -1
		val_new = 0 - val_new;
end

