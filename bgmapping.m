function [dat] = bgmapping(start_file, vgstart, delvg, vgfinal,savedata)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% Saving Data Protocol
if ~exist('savedata','var')
    % third parameter does not exist, so default it to something
     savedata = 'ds';
end

% Counters
i = start_file; %File Counter
% counter = 0; %Loop Counter
numfiles = abs((vgfinal - vgstart))./abs(delvg)+1; %Number of Files
vgi = vgstart; %Initial Magnetic Field
xyname = []; zname = [];

%Length extraction
for k = [1:1:numfiles]
    
    %Load Data (preloaded or formatted)
    filename = sprintf('exp%d',i);
    if isfile(['data_' filename '.mat']) == 1
        load(['data_' filename '.mat']) 
    else
        filename =filesearch(filename);
        data = btransportdata(filename,0.00005,15,'s'); 
    end 
    
    len(:,k) = length(data.B);
    
    %counter = 1;
    i = i + 3;
end

%Determine longest array
maxdatasize = max(len);

%Pad cells to prevent errors 
dat.B = NaN(maxdatasize,k); dat.phiphio = NaN(maxdatasize,k); dat.phiophi = NaN(maxdatasize,k);
dat.Vg = NaN(maxdatasize,k); dat.n = NaN(maxdatasize,k); dat.nno = NaN(maxdatasize,k);

dat.r = NaN(maxdatasize,k); dat.drdB = NaN(maxdatasize,k);

dat.g = NaN(maxdatasize,k);dat.dgdB = NaN(maxdatasize,k);

dat.rfit = NaN(maxdatasize,k); dat.r2fit = NaN(maxdatasize,k); dat.r3fit = NaN(maxdatasize,k);

dat.r2 = NaN(maxdatasize,k); dat.dr2dB = NaN(maxdatasize,k);
dat.g2 = NaN(maxdatasize,k); dat.dg2dB = NaN(maxdatasize,k);
dat.r3 = NaN(maxdatasize,k); dat.dr3dB = NaN(maxdatasize,k);
dat.g3 = NaN(maxdatasize,k); dat.dg3dB = NaN(maxdatasize,k);

i = start_file; %File Counter
%counter = 0; %Loop Counter

%Data Extraction
for k = [1:1:numfiles]
    
    %Load Data (preloaded or formatted)
    filename = sprintf('exp%d',i);
    if isfile(['data_' filename '.mat']) == 1
        load(['data_' filename '.mat']) 
    else
        filename =filesearch(filename);
        data = btransportdata(filename,0.00005,15,'s'); 
    end 
    
    %Data extraction for plotting
    xy = 1;
    dat.B(1:len(k),k) = data.B; xyname{1,xy} = 'B (T)'; xyname{2,xy} = 'B';
    dat.phiphio(1:len(k),k) = data.phiphio; xyname{1,xy+1} = [char(981) '/' char(981) 'o']; xyname{2,xy+1} = 'phiphio';
    dat.phiophi(1:len(k),k) = data.phiophi; xyname{1,xy+2} = [char(981) 'o/' char(981)]; xyname{2,xy+2} = 'phiophi';
    dat.Vg(1:len(k),k) = ones(len(k),1).*vgi; xyname{1,xy+3} = 'Vg (V)'; xyname{2,xy+3} = 'Vg';
    dat.n(1:len(k),k) = data.n.*dat.Vg(1:len(k),k); xyname{1,xy+4} = ['n (1/cm' char(0178) ')']; xyname{2,xy+4} = 'n';
    dat.nno(1:len(k),k) = dat.n(1:len(k),k)./12; xyname{1,xy+5} = 'n/n_{o}'; xyname{2,xy+5} = 'nno';
    
    z = 1;
    dat.r(1:len(k),k) = data.r; zname{1,z} = ['r' ' (' char(911) ')']; zname{2,z} = 'r'; 
    dat.rfit(1:len(k),k) = data.rfit; zname{1,z+1} = ['r_{fit}' ' (' char(911) ')']; zname{2,z+1} = 'rfit';
    dat.drdB(1:len(k),k) = data.drdB; zname{1,z+2} = 'dr/dB'; zname{2,z+2} = 'drdB';
    
    dat.g(1:len(k),k) = data.g; zname{1,z+3} = 'g (S)'; zname{2,z+3} = 'g';
    dat.dgdB(1:len(k),k) = data.dg2dB; zname{1,z+4} = 'dg/dB'; zname{2,z+4} = 'dgdB';
    
    
    numdata = 1; 
    
    if numel(fields(data)) > 7
        
        dat.r2(1:len(k),k) = data.r2; zname{1,z+5} = ['r_{2}' ' (' char(911) ')']; zname{2,z+5} = 'r2';
        dat.r2fit(1:len(k),k) = data.r2fit; zname{1,z+6} = 'r2fit (Ohms)'; zname{2,z+6} = 'r2fit';
        dat.dr2dB(1:len(k),k) = data.dr2dB; zname{1,z+7} = 'dr2dB (Ohms)'; zname{2,z+7} = 'dr2dB';
        
        dat.g2(1:len(k),k) = data.g2; zname{1,z+8} = 'g2 (S)'; zname{2,z+8} = 'g2';
        dat.dg2dB(1:len(k),k) = data.dg2dB; zname{1,z+9} = 'dg2/dB'; zname{2,z+9} = 'dg2dB';
        
        numdata = 2;
        
        if numel(fields(data)) > 11
            
            dat.r3(1:len(k),k) = data.r3; zname{1,z+10} = ['r3' ' (' char(911) ')']; zname{2,z+10} = 'r3';
            dat.r3fit(1:len(k),k) = data.r3fit; zname{1,z+11} = ['r3fit' ' (' char(911) ')']; zname{2,z+11} = 'r3fit';
            dat.dr3dB(1:len(k),k) = data.dr3dB; zname{1,z+12} = ['dr3dB' ' (' char(911) ')']; zname{2,z+12} = 'dr3dB';
            
            dat.g3(1:len(k),k) = data.g3; zname{1,z+13} = 'g3 (S)'; zname{2,z+13} = 'g3';
            dat.dg3dB(1:len(k),k) = data.dg3dB; zname{1,z+14} = 'dg3/dB'; zname{2,z+14} = 'dg3dB';
            
            numdata = 3;
        end 
    end 
    
    %counter = 1;
    %i = i + 0;
    
    i = i + 3;
    vgi = vgi + delvg; 
end

dat.xyname = xyname;
dat.zname = zname;

if savedata == 'ds'
    
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
            map = pcolor(Vg,B, r);
            set(map,'EdgeColor','none')
            shading interp;
            colorbar;
            xlabel('vgf (V)') 
            ylabel('B (T)')
            zlabel('R (k\Ohm)')
            title('R')
            pbaspect([1 1 1])


            subplot(1,3,2)
            map = pcolor(Vg,B, r2);
            set(map,'EdgeColor','none')
            shading interp;
            colorbar;
            xlabel('vgf (V)') 
            ylabel('B (T)')
            zlabel('R (k\Ohm)')
            title('R1')
            pbaspect([1 1 1])

            subplot(1,3,3)
            map = pcolor(Vg,B, r3);
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
            map = pcolor(Vg,1./B, 1./rfit);
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
            map = pcolor(Vg,1./B, 1./r2fit);
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
            map = pcolor(Vg,1./B, 1./r3fit);
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
            map = pcolor(Vg,B, ((drdB)));
            set(map,'EdgeColor','none')
            shading interp;
            colorbar;
            xlabel('vgf (V)') 
            ylabel('B (T)')
            zlabel('R (k\Ohm)')
            title('R')
            pbaspect([1 1 1])


            subplot(1,3,2)
            map = pcolor(Vg,B, (((dr2dB))));
            set(map,'EdgeColor','none')
            shading interp;
            colorbar;
            xlabel('Vg (V)') 
            ylabel('B (T)')
            zlabel('R (k\Ohm)')
            title('R1')
            pbaspect([1 1 1])

            subplot(1,3,3)
            map = pcolor(Vg,B, (((dr3dB))));
            set(map,'EdgeColor','none')
            shading interp;
            colorbar;
            xlabel('Vg (V)') 
            ylabel('B (T)')
            zlabel('R (k\Ohm)')
            title('R2')
            pbaspect([1 1 1])         

            hAx = axes('Parent',hTabs(4));
            %Vg vs d(R)/dV
            subplot(1,3,1)
            map = pcolor(Vg,B, log(abs(drdB)));
            set(map,'EdgeColor','none')
            shading interp;
            colorbar;
            xlabel('Vg (V)') 
            ylabel('B (T)')
            zlabel('R (k\Ohm)')
            title('R')
            pbaspect([1 1 1])

            subplot(1,3,2)
            map = pcolor(Vg,B, log(abs((dr2dB))));
            set(map,'EdgeColor','none')
            shading interp;
            colorbar;
            xlabel('Vg (V)') 
            ylabel('B (T)')
            zlabel('R (k\Ohm)')
            title('R1')
            pbaspect([1 1 1])

            subplot(1,3,3)
            map = pcolor(Vg,B, log(abs((dr3dB))));
            set(map,'EdgeColor','none')
            shading interp;
            colorbar;
            xlabel('Vg (V)') 
            ylabel('B (T)')
            zlabel('R (k\Ohm)')
            title('R2')
            pbaspect([1 1 1])         
elseif savedata == 's'    
    save(['mappingdata' '.mat'],'dat')
end 
 
end

