function [ca_code] = gcacode(prn_no)
% This function generates GPS C/A code for a given prn number .
% Reference - ICD-200C page 8,9
% Author - Nagaraj CS

g1 = ones(1,10);
g2 = ones(1,10);
ca_code = zeros(1,1023);
s1=0;
s2=0;
g2i=0;
l=1;

phase = [2 6;
					3 7;
					4 8;
					5 9;
					1 9;
					2 10;
					1 8;
					2 9;
					3 10;
					2 3;
					3 4;
					5 6;
					6 7;
					7 8;
					8 9;
					9 10;
					1 4;
					2 5;
					3 6;
					4 7;
					5 8;
					6 9;
					1 3;
					4 6;
					5 7;
					6 8;
					7 9;
					8 10;
					1 6;
					2 7;
					3 8;
					4 9;
					5 10;];

if (prn_no < 1) | (prn_no > 32)
	disp('prn number is not in GPS list');
	return;
end	

for l = 1:1023

	g2i = xor(g2(phase(prn_no,1)),g2(phase(prn_no,2)));
	ca_code(1,l) = xor(g1(10),g2i);
	
	s1 = xor(g1(3),g1(10));
	g1(2:10) = g1(1:9);
	g1(1) = s1;
	
	s2 = xor(xor(xor(xor(xor(g2(2),g2(3)),g2(6)),g2(8)),g2(9)),g2(10));
	g2(2:10) = g2(1:9);
	g2(1) = s2;
	
end

