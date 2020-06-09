function [outputArg1,outputArg2] = testfunction(x,y,varargin)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

for i = size(varargin,2)
    var = varargin{i}; 
    if var == 'Linear Position' 
        LinearPosition = 5; 
    else 
    
end 


plot(x,y)
end

