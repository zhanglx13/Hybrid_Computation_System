% @val		input floating point number
% @sign		sign of the input, 1 for positive and -1 for negetive and 0 for zero
% @int		integer part of the input
% @frac		fraction part of the input
function [ sign, int, frac ] = seperate( val )
% Seperate the integer and fractional part of 
% input floating point number
	if val == 0
		sign = 0;
		val_abs = val;
	elseif val > 0
		sign = 1;	
		val_abs = val;
	else 
		sign = -1;
		val_abs = 0 - val;
	end
	int = floor(val_abs);
	frac = val_abs - int;
end

