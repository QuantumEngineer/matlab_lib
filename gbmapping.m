function [ output_args ] = gbmapping(start_file, Bstart, delB, Bfinal)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
i = start_file; 
counter = 0; 
numfiles = abs((Bfinal - Bstart))./abs(delB)+1; 
B = Bstart;

for k = [1:1:numfiles]
    filename = sprintf('exp%d',i);
    if isfile(['data_' filename '.mat']) == 1
        load(['data_' filename '.mat']) 
    else
        filename =filesearch(filename);
        data = transportdata(filename,0.00005,15,'s'); 
    end 

    gate(:,k) = data.gate;
    n(:,k) = data.n;
    r(:,k) = data.r;
    g(:,k) = data.g; 
    Bf(:,k) = ones(size(gate,1),1).*B;
    drdv(:,k) = data.drdv;
    
    numdata = 1; 
    
    if numel(fields(data)) > 6
        
        r2(:,k) = data.r2;
        dr2dv(:,k) = data.dr2dv;
        g2(:,k) = data.g2; 
        dg2dv(:,k) = data.dg2dv;
        
        numdata = 2;
        
        if numel(fields(data)) > 10
            
            r3(:,k) = data.r3;
            dr3dv(:,k) = data.dr3dv;
            g3(:,k) = data.g3; 
            dg3dv(:,k) = data.dg3dv;
            
            numdata = 3;
        end 
    end 
    
    counter = 1;
    i = i + 4;
    B = B + delB; 
end


hFig = figure('Name',['Data ' num2str(start_file)],'NumberTitle','off','Color', 'w');

colorscheme = othercolor('RdBu10',1024);
flippedJetColorMap = (colorscheme);
colormap(flippedJetColorMap);

s = warning('off', 'MATLAB:uitabgroup:OldVersion');
hTabGroup = uitabgroup('Parent',hFig);
warning(s);
hTabs(1) = uitab('Parent',hTabGroup, 'Title','Gate, B, R');
hTabs(2) = uitab('Parent',hTabGroup, 'Title','Gate, B, log(R)');
hTabs(3) = uitab('Parent',hTabGroup, 'Title','Gate, B, dR/dV');
hTabs(4) = uitab('Parent',hTabGroup, 'Title','Gate, B, log(dR/dV)');
hTabs(5) = uitab('Parent',hTabGroup, 'Title','Raw - 1/B vs R');
hTabs(6) = uitab('Parent',hTabGroup, 'Title','Background Subtraction - 1/B vs R');
hTabs(7) = uitab('Parent',hTabGroup, 'Title','Derivative - 1/B vs R');
hTabs(8) = uitab('Parent',hTabGroup, 'Title','Background Subtraction + Derivative - 1/B vs R');

set(hTabGroup, 'SelectedTab',hTabs(1));

        hAx = axes('Parent',hTabs(1));
        %Gate vs R
        subplot(2,2,1)
        map = pcolor(gate,Bf, r);
        set(map,'EdgeColor','none')
        shading interp;
        colorbar;
        xlabel('Gate (V)') 
        ylabel('B (T)')
        zlabel('R (k\Ohm)')
        title('R')
        pbaspect([1 1 1])
        
       
        subplot(2,2,3)
        map = pcolor(gate,Bf, r2);
        set(map,'EdgeColor','none')
        shading interp;
        colorbar;
        xlabel('Gate (V)') 
        ylabel('B (T)')
        zlabel('R (k\Ohm)')
        title('R1')
        pbaspect([1 1 1])
        subplot(2,2,4)
        map = pcolor(gate,Bf, r3);
        set(map,'EdgeColor','none')
        shading interp;
        colorbar;
        xlabel('Gate (V)') 
        ylabel('B (T)')
        zlabel('R (k\Ohm)')
        title('R2')
        pbaspect([1 1 1])

        hAx = axes('Parent',hTabs(2));
        %Gate vs Log(R)
        subplot(2,2,1)
        map = pcolor(gate,Bf, log(r));
        set(map,'EdgeColor','none')
        shading interp;
        colorbar;
        xlabel('Gate (V)') 
        ylabel('B (T)')
        zlabel('R (k\Ohm)')
        title('R')
        pbaspect([1 1 1])
       
        subplot(2,2,3)
        map = pcolor(gate,Bf, log(abs((r2))));
        set(map,'EdgeColor','none')
        shading interp;
        colorbar;
        xlabel('Gate (V)') 
        ylabel('B (T)')
        zlabel('R (k\Ohm)')
        title('R1')
        pbaspect([1 1 1])
        subplot(2,2,4)
        map = pcolor(gate,Bf, log(abs((r2))));
        set(map,'EdgeColor','none')
        shading interp;
        colorbar;
        xlabel('Gate (V)') 
        ylabel('B (T)')
        zlabel('R (k\Ohm)')
        title('R2')
        pbaspect([1 1 1]) 
        %}
         hAx = axes('Parent',hTabs(3));
        %Gate vs d(R)/dV
        subplot(2,2,1)
        map = pcolor(gate,Bf, ((drdv)));
        set(map,'EdgeColor','none')
        shading interp;
        colorbar;
        xlabel('Gate (V)') 
        ylabel('B (T)')
        zlabel('R (k\Ohm)')
        title('R')
        pbaspect([1 1 1])
        
        
        subplot(2,2,3)
        map = pcolor(gate,Bf, (((dr2dv))));
        set(map,'EdgeColor','none')
        shading interp;
        colorbar;
        xlabel('Gate (V)') 
        ylabel('B (T)')
        zlabel('R (k\Ohm)')
        title('R1')
        pbaspect([1 1 1])
        subplot(2,2,4)
        map = pcolor(gate,Bf, (((dr3dv))));
        set(map,'EdgeColor','none')
        shading interp;
        colorbar;
        xlabel('Gate (V)') 
        ylabel('B (T)')
        zlabel('R (k\Ohm)')
        title('R2')
        pbaspect([1 1 1])         

        hAx = axes('Parent',hTabs(4));
        %Gate vs d(R)/dV
        subplot(2,2,1)
        map = pcolor(gate,Bf, log(abs(drdv)));
        set(map,'EdgeColor','none')
        shading interp;
        colorbar;
        xlabel('Gate (V)') 
        ylabel('B (T)')
        zlabel('R (k\Ohm)')
        title('R')
        pbaspect([1 1 1])
        subplot(2,2,3)
        map = pcolor(gate,Bf, log(abs((dr2dv))));
        set(map,'EdgeColor','none')
        shading interp;
        colorbar;
        xlabel('Gate (V)') 
        ylabel('B (T)')
        zlabel('R (k\Ohm)')
        title('R1')
        pbaspect([1 1 1])
        subplot(2,2,4)
        map = pcolor(gate,Bf, log(abs((dr3dv))));
        set(map,'EdgeColor','none')
        shading interp;
        colorbar;
        xlabel('Gate (V)') 
        ylabel('B (T)')
        zlabel('R (k\Ohm)')
        title('R2')
        pbaspect([1 1 1])         
        
        
    
end

