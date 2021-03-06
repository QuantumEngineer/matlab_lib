function [dat] = bgmapping(start_file, vgstart, delvg, vgfinal,varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

vsd = 0.0005; do2 = 20; savedata = 's'; a = 11; w = 1; l = 1;

for j = [1:2:size(varargin,2)]
    if strcmp(varargin{j},'vsd') == 1
        vsd = varargin{j+1};
    elseif strcmp(varargin{j},'bnthickness') == 1 
        do2 = varargin{j+1};
    elseif strcmp(varargin{j},'width') == 1 
        w = varargin{j+1};
    elseif strcmp(varargin{j},'length') == 1 
        l = varargin{j+1};
    elseif strcmp(varargin{j},'savedata') == 1 
        savedata = varargin{j+1};
    elseif strcmp(varargin{j},'moire') == 1 
        a = varargin{j+1};
    end 
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
        data = btransportdata(filename,'vsd',0.001,'bnthickness',30,'savedata','s'); 
    end 
    
    len(:,k) = length(data.B);
    
    %counter = 1;
    i = i;
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
dat.gfit = NaN(maxdatasize,k); dat.g2fit = NaN(maxdatasize,k); dat.g3fit = NaN(maxdatasize,k);

dat.r2 = NaN(maxdatasize,k); dat.rho2 = NaN(maxdatasize,k); dat.dr2dB = NaN(maxdatasize,k);
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
        data = btransportdata(filename,0.001,30,'s'); 
    end 
    
    %Data extraction for plotting

    dat.B(1:len(k),k) = data.B; xyname.B = 'B (T)';
    dat.phiphio(1:len(k),k) = data.phiphio; xyname.phiphio = '\phi/\phi_{o}';
    dat.phiophi(1:len(k),k) = data.phiophi; xyname.phiophi = '\phi_{o}/\phi'; 
    dat.Vg(1:len(k),k) = ones(len(k),1).*vgi; xyname.Vg = 'V_{g} (V)';
    dat.n(1:len(k),k) = data.n.*dat.Vg(1:len(k),k); xyname.n = 'n (cm^{-2})'; 
    dat.nno(1:len(k),k) = dat.n(1:len(k),k)./12; xyname.nno = 'n/n_{o}'; 

    dat.r(1:len(k),k) = data.r; zname.r = 'r (\Ohms)';
    dat.rfit(1:len(k),k) = data.rfit; zname.rfit = ['r_{fit}' ' (' char(911) ')']; 
    dat.drdB(1:len(k),k) = data.drdB; zname.drdB = 'dr/dB';
    
    dat.g(1:len(k),k) = data.g; zname.g = 'g (S)';
    dat.gfit(1:len(k),k) = data.gfit; zname.gfit = ['g_{fit}' ' (S)'];
    dat.dgdB(1:len(k),k) = data.dg2dB; zname.dgdB = 'dg/dB';
    
    
    numdata = 1; 
    
    if numel(fields(data)) > 7
        
        dat.r2(1:len(k),k) = data.r2; zname.r2 = ['r_{2}' ' (' char(911) ')'];
        dat.rho2(1:len(k),k) = data.rho2; zname.rho2 = ['r_{2}' ' (' char(911) ')'];
        dat.r2fit(1:len(k),k) = data.r2fit; zname.r2fit = 'r2fit (Ohms)'; 
        dat.dr2dB(1:len(k),k) = data.dr2dB; zname.dr2dB = 'dr2dB (Ohms)';
        
        dat.g2(1:len(k),k) = data.g2; zname.g2 = 'g2 (S)';
        dat.g2fit(1:len(k),k) = data.g2fit; zname.g2fit = ['g2_{fit}' ' (S)'];
        dat.dg2dB(1:len(k),k) = data.dg2dB; zname.dg2dB = 'dg2/dB';
        
        numdata = 2;
        
        if numel(fields(data)) > 11
            
            dat.r3(1:len(k),k) = data.r3; zname.r3 = ['r3' ' (' char(911) ')'];
            dat.r3fit(1:len(k),k) = data.r3fit; zname.r3fit = ['r3fit' ' (' char(911) ')']; 
            dat.dr3dB(1:len(k),k) = data.dr3dB; zname.dr3dB = ['dr3dB' ' (' char(911) ')']; 
            
            dat.g3(1:len(k),k) = data.g3; zname.g3 = 'g3 (S)'; 
            dat.g3fit(1:len(k),k) = data.g3fit; zname.g3fit = ['g3_{fit}' ' (S)'];
            dat.dg3dB(1:len(k),k) = data.dg3dB; zname.dg3dB = 'dg3/dB';
            
            numdata = 3;
        end 
    end 
    
    %counter = 1;
    %i = i + 0;
    
    i = i + 3;
    vgi = vgi + delvg; 
end

dat.xy = xyname;
dat.z = zname;
dat.title = ['Map of exp' num2str(start_file) ' to exp' num2str((i-3))];

if savedata == 'ds'
    
    hFig = figure('Name',['Data ' num2str(start_file)],'NumberTitle','off','Color', 'w');

    colorscheme = othercolor('Greys9',1024);
    flippedJetColorMap = (colorscheme);
    colormap(flippedJetColorMap);

    s = warning('off', 'MATLAB:uitabgroup:OldVersion');
    hTabGroup = uitabgroup('Parent',hFig);
    warning(s);
    hTabs(1) = uitab('Parent',hTabGroup, 'Title','Vg, B, R');
    hTabs(2) = uitab('Parent',hTabGroup, 'Title','Vg, B, Rfit');
    hTabs(3) = uitab('Parent',hTabGroup, 'Title','Vg, B, dR/dB');


    set(hTabGroup, 'SelectedTab',hTabs(1));

            hAx = axes('Parent',hTabs(1));
            %vgf vs R
            subplot(1,3,1)
            map = pcolor(dat.Vg,dat.B, dat.r);
            set(map,'EdgeColor','none')
            shading interp;
            colorbar;
            xlabel('Vg (V)') 
            ylabel('B (T)')
            zlabel('R (\Ohm)')
            title('R')
            pbaspect([1 1 1])


            subplot(1,3,2)
            map = pcolor(dat.Vg,dat.B, dat.r2);
            set(map,'EdgeColor','none')
            shading interp;
            colorbar;
            xlabel('Vg (V)') 
            ylabel('B (T)')
            zlabel('R1 (\Ohm)')
            title('R1')
            pbaspect([1 1 1])

            subplot(1,3,3)
            map = pcolor(dat.Vg,dat.B, dat.r3);
            set(map,'EdgeColor','none')
            shading interp;
            colorbar;
            xlabel('Vg (V)') 
            ylabel('B (T)')
            zlabel('R2 (\Ohm)')
            title('R2')
            pbaspect([1 1 1])

            hAx = axes('Parent',hTabs(2));

            %vgf vs Log(R)
            subplot(1,3,1)
            map = pcolor(dat.Vg,dat.B, dat.rfit);
            set(map,'EdgeColor','none')
            shading interp;
            colorbar;
            xlabel('Vg (V)') 
            ylabel('B (T)')
            zlabel('Rfit (\Ohm)')
            title('Rfit')
            pbaspect([1 1 1])

            subplot(1,3,2)
            map = pcolor(dat.Vg,dat.B, dat.r2fit);
            set(map,'EdgeColor','none')
            shading interp;
            colorbar;
            xlabel('Vg (V)') 
            ylabel('B (T)')
            zlabel('R1fit (\Ohm)')
            title('R1fit')
            pbaspect([1 1 1])
            
            subplot(1,3,3)
            map = pcolor(dat.Vg,dat.B, dat.r3fit);
            set(map,'EdgeColor','none')
            shading interp;
            colorbar;
            xlabel('Vg (V)') 
            ylabel('B (T)')
            zlabel('R2fit (\Ohm)')
            title('R2fit')
            pbaspect([1 1 1]) 


             hAx = axes('Parent',hTabs(3));
            %vgf vs d(R)/dV
            subplot(1,3,1)
            map = pcolor(dat.Vg,dat.B, dat.drdB);
            set(map,'EdgeColor','none')
            shading interp;
            colorbar;
            xlabel('Vg (V)') 
            ylabel('B (T)')
            zlabel('dRdB (\Ohm)')
            title('dRdB')
            pbaspect([1 1 1])


            subplot(1,3,2)
            map = pcolor(dat.Vg,dat.B, dat.dr2dB);
            set(map,'EdgeColor','none')
            shading interp;
            colorbar;
            xlabel('Vg (V)') 
            ylabel('B (T)')
            zlabel('dR1dB (\Ohm)')
            title('dR1dB')
            pbaspect([1 1 1])

            subplot(1,3,3)
            map = pcolor(dat.Vg,dat.B, dat.dr3dB);
            set(map,'EdgeColor','none')
            shading interp;
            colorbar;
            xlabel('Vg (V)') 
            ylabel('B (T)')
            zlabel('dR2dB (\Ohm)')
            title('dR2dB')
            pbaspect([1 1 1])         

elseif savedata == 's'    
    save(['mappingdata' '.mat'],'dat')
end 
 
end

