function [ output_args ] = gbmapping(start_file, vgstart, delvg, vgfinal)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% Counters
i = start_file; %File Counter
counter = 0; %Loop Counter
numfiles = abs((vgfinal - vgstart))./abs(delvg)+1; %Number of Files
vg = vgstart; %Initial Magnetic Field

for k = [1:1:numfiles]
    filename = sprintf('exp%d',i);
    if isfile(['data_' filename '.mat']) == 1
        load(['data_' filename '.mat']) 
    else
        filename =filesearch(filename);
        data = btransportdata(filename,0.00005,15,'s'); 
    end 
    
    B = data.B;
    len(:,k) = length(data.B);
    
    counter = 1;

    i = i + 3;
end

maxdatasize = max(len);

B = NaN(maxdatasize,k);r = zeros(maxdatasize,k);g = zeros(maxdatasize,k);
vgf = NaN(maxdatasize,k);drdv = zeros(maxdatasize,k);
r2 = zeros(maxdatasize,k);dr2dv = zeros(maxdatasize,k);
g2 = zeros(maxdatasize,k);dg2dv = zeros(maxdatasize,k);
r3 = zeros(maxdatasize,k);dr3dv = zeros(maxdatasize,k);
g3 = zeros(maxdatasize,k);dg3dv = zeros(maxdatasize,k);

i = start_file; %File Counter
counter = 0; %Loop Counter

for k = [1:1:numfiles]
    
        filename = sprintf('exp%d',i);
    if isfile(['data_' filename '.mat']) == 1
        load(['data_' filename '.mat']) 
    else
        filename =filesearch(filename);
        data = btransportdata(filename,0.00005,15,'s'); 
    end 
    
    B(1:len(k),k) = data.B;
    %n(:,k) = data.n;
    r(1:len(k),k) = data.r;
    rfit(1:len(k),k) = data.rfit;
    g(1:len(k),k) = data.g; 
    vgf(1:len(k),k) = ones(len(k),1).*vg;
    drdv(1:len(k),k) = data.drdv;
    
    numdata = 1; 
    
    if numel(fields(data)) > 7
        
        r2(1:len(k),k) = data.r2;
        r2fit(1:len(k),k) = data.r2fit;
        dr2dv(1:len(k),k) = data.dr2dv;
        g2(1:len(k),k) = data.g2; 
        dg2dv(1:len(k),k) = data.dg2dv;
        
        numdata = 2;
        
        if numel(fields(data)) > 11
            
            r3(1:len(k),k) = data.r3;
            r3fit(1:len(k),k) = data.r3fit;
            dr3dv(1:len(k),k) = data.dr3dv;
            g3(1:len(k),k) = data.g3; 
            dg3dv(1:len(k),k) = data.dg3dv;
            
            numdata = 3;
        end 
    end 
    
    counter = 1;
    i = i+ 0
    i = i + 3;
    vg = vg + delvg; 
end



hFig = figure('Name',['Data ' num2str(start_file)],'NumberTitle','off','Color', 'w');

colorscheme = othercolor('Greys9',1024);
flippedJetColorMap = (colorscheme);
colormap(flippedJetColorMap);

s = warning('off', 'MATLAB:uitabgroup:OldVersion');
hTabGroup = uitabgroup('Parent',hFig);
warning(s);
hTabs(1) = uitab('Parent',hTabGroup, 'Title','vgf, B, R');
hTabs(2) = uitab('Parent',hTabGroup, 'Title','vgf, B, log(R)');
hTabs(3) = uitab('Parent',hTabGroup, 'Title','vgf, B, dR/dV');
hTabs(4) = uitab('Parent',hTabGroup, 'Title','vgf, B, log(dR/dV)');


set(hTabGroup, 'SelectedTab',hTabs(1));

        hAx = axes('Parent',hTabs(1));
        %vgf vs R
        subplot(1,3,1)
        map = pcolor(vgf,B, r);
        set(map,'EdgeColor','none')
        shading interp;
        colorbar;
        xlabel('vgf (V)') 
        ylabel('B (T)')
        zlabel('R (k\Ohm)')
        title('R')
        pbaspect([1 1 1])
        
       
        subplot(1,3,2)
        map = pcolor(vgf,B, r2);
        set(map,'EdgeColor','none')
        shading interp;
        colorbar;
        xlabel('vgf (V)') 
        ylabel('B (T)')
        zlabel('R (k\Ohm)')
        title('R1')
        pbaspect([1 1 1])
        
        subplot(1,3,3)
        map = pcolor(vgf,B, r3);
        set(map,'EdgeColor','none')
        shading interp;
        colorbar;
        xlabel('vgf (V)') 
        ylabel('B (T)')
        zlabel('R (k\Ohm)')
        title('R2')
        pbaspect([1 1 1])

        hAx = axes('Parent',hTabs(2));
        
        %vgf vs Log(R)
        subplot(1,3,1)
        map = pcolor(vgf,1./B, rfit);
        set(map,'EdgeColor','none')
        shading interp;
        colorbar;
        xlabel('vgf (V)') 
        ylabel('B (T)')
        zlabel('R (k\Ohm)')
        title('R')
        pbaspect([1 1 1])
        ylim([.1 .5])
        
        subplot(1,3,2)
        map = pcolor(vgf,1./B, r2fit);
        set(map,'EdgeColor','none')
        shading interp;
        colorbar;
        xlabel('vgf (V)') 
        ylabel('B (T)')
        zlabel('R (k\Ohm)')
        title('R1')
        pbaspect([1 1 1])
        ylim([.1 .5])
        
        subplot(1,3,3)
        map = pcolor(vgf,1./B, r3fit);
        set(map,'EdgeColor','none')
        shading interp;
        colorbar;
        xlabel('vgf (V)') 
        ylabel('B (T)')
        zlabel('R (k\Ohm)')
        title('R2')
        pbaspect([1 1 1]) 
         ylim([.1 .5])
         
         hAx = axes('Parent',hTabs(3));
        %vgf vs d(R)/dV
        subplot(1,3,1)
        map = pcolor(vgf,B, ((drdv)));
        set(map,'EdgeColor','none')
        shading interp;
        colorbar;
        xlabel('vgf (V)') 
        ylabel('B (T)')
        zlabel('R (k\Ohm)')
        title('R')
        pbaspect([1 1 1])
        
        
        subplot(1,3,2)
        map = pcolor(vgf,B, (((dr2dv))));
        set(map,'EdgeColor','none')
        shading interp;
        colorbar;
        xlabel('vgf (V)') 
        ylabel('B (T)')
        zlabel('R (k\Ohm)')
        title('R1')
        pbaspect([1 1 1])
        
        subplot(1,3,3)
        map = pcolor(vgf,B, (((dr3dv))));
        set(map,'EdgeColor','none')
        shading interp;
        colorbar;
        xlabel('vgf (V)') 
        ylabel('B (T)')
        zlabel('R (k\Ohm)')
        title('R2')
        pbaspect([1 1 1])         

        hAx = axes('Parent',hTabs(4));
        %vgf vs d(R)/dV
        subplot(1,3,1)
        map = pcolor(vgf,B, log(abs(drdv)));
        set(map,'EdgeColor','none')
        shading interp;
        colorbar;
        xlabel('vgf (V)') 
        ylabel('B (T)')
        zlabel('R (k\Ohm)')
        title('R')
        pbaspect([1 1 1])
        
        subplot(1,3,2)
        map = pcolor(vgf,B, log(abs((dr2dv))));
        set(map,'EdgeColor','none')
        shading interp;
        colorbar;
        xlabel('vgf (V)') 
        ylabel('B (T)')
        zlabel('R (k\Ohm)')
        title('R1')
        pbaspect([1 1 1])
        
        subplot(1,3,3)
        map = pcolor(vgf,B, log(abs((dr3dv))));
        set(map,'EdgeColor','none')
        shading interp;
        colorbar;
        xlabel('vgf (V)') 
        ylabel('B (T)')
        zlabel('R (k\Ohm)')
        title('R2')
        pbaspect([1 1 1])         
        
    
end

