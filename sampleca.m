function [sampcode] = sampleca(ca_code,sampfreq)
% This function samples the C/A code with the given sampling frequency.
% Assumption : code duration is 1 millisecond
% Usage : [sampcode] = sampleca(ca_code,sampfreq in Hz)
% Author - Nagaraj CS

% convert sampling frequency to the corresponding value in milliseconds.
s_freq = floor(sampfreq / 1e3);

if s_freq < length(ca_code)
	disp(' Want to undersample ? Huh, this is not the function');
	return;
end

sampcode = zeros(1,s_freq);

b_period = 1e-3 / length(ca_code);					% bit period
s_period = 1e-3 / s_freq;										% sampling period

cur_per = s_period;
%cur_per = 0;
l = 1;

for k=1:s_freq

	sampcode(k) = ca_code(l);
	
	cur_per = cur_per + s_period;
	if cur_per >= b_period 
		cur_per = cur_per - b_period;
		l = l +1;
		if l > length(ca_code)
			l = 1;
		end
	end
	
end
