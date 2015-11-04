% @int_b		input string of binary representation
% @n			number of bit-precision
% @int_new		output integer with n-bit precision
function [ int_new ] = truncate_int( int_b, n )
  %% This function assumes that the number of bits of int_b
  %% is bigger than n
    int_new_b = int_b;
    num_ele = numel(int_b);
    for i = (n+1) : num_ele
        int_new_b(i) = '0';
    end
    int_new = bin2dec(int_new_b);
end

