function [] = niceplot(size)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

    if ~exist('size','var')
        % third parameter does not exist, so default it to something
         size = 16;
    end
    
    set(gca, 'fontsize', size, 'linewidth', 1.50, 'FontWeight','bold');
    set( gca ,'FontName','Helvetica' );
    
  

end

