function [ data ] = btransportdata(filename,varargin)

%transportdata - Converts text file from Wu Shi's ACDC aquisition program
%   in a cell-array that contains converted data. This cell array contains
%              - Gate Voltage (V): Gate applied to the device
%              - n (electrons/cm^2): Carrier density of sample based on
%              sample geometry. 
%              - r (ohms): Resistance of channel based on vsd
%              - g (siemens): Conductance of channel based on vsd 

vsd = 0.0005; do2 = 20; savedata = 'ds'; a = 11; w = 1; l = 1;

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

% Math

% Carrier Density Conversion 
eo = 8.854.*10.^(-12); % F/m Electric Constant
er1 = 4; % Dielectric Constant
er2 = 4; 
ec = 1.6021766.*10.^(-19); % C Charge of Electron 
do1 = 285; % nm Dielectric Thickness Oxide
%do2 =20; %nm Dielectric Thickness BN 
d1 = do1.*10^(-9);
d2 = do2.*10^(-9);
con = 1./10000; % Nm to meV 
h = 6.62607.*10.^(-34); % Js

%Quantum Flux Calculation 
phio = h./ec; %Magnetic Flux Quanta
%a = 11; %Moire Size
A = a.^2*sqrt(3)./2; 

% Data extraction
dat = (csvread(filename,1));
%if dat(1,1) >= dat(end,1)
%    dat = flipud(dat); 
%end 
data = {};

% Check for number of channels
[~, channels] = size(dat);

%Extrac primary channel data 
data.B = dat(:,1)./10000; 
data.phiphio = data.B.*A./(10.^18.*phio);
data.phiophi = 1./data.phiphio;
data.n = con.*(eo./ec).*(er1.*er2)./(d1.*er2 + d2.*er1); 

data.g = dat(:,2)./vsd; 
data.gfit = data.g - polyval(polyfit(data.B,data.g,6),data.B);
data.dgdB = diff([eps; data.g])./diff([eps; data.B]);

data.r = vsd./dat(:,2);
data.rfit = data.r - polyval(polyfit(data.B,data.r,6),data.B);
data.drdB = diff([eps; data.r])./diff([eps; data.B]);

%Extract other channel data

if channels > 2

    data.r2 = dat(:,3);
    data.r2fit = data.r2 - polyval(polyfit(data.B,data.r2,6),data.B);
    data.dr2dB = diff([eps; data.r2])./diff([eps; data.B]);
    
    data.g2 = 1./data.r2;
    data.g2fit = data.g2 - polyval(polyfit(data.B,data.g2,6),data.B);
    data.dg2dB = diff([eps; data.g2])./diff([eps; data.B]); 
    
    if channels > 3
        
        data.r3 = dat(:,4);
        data.r3fit = data.r3 - polyval(polyfit(data.B,data.r3,6),data.B);
        data.dr3dB = diff([eps; data.r3])./diff([eps; data.B]);
        
        data.g3 = 1./data.r3;
        data.g3fit = data.g3 - polyval(polyfit(data.B,data.g3,6),data.B);
        data.dg3dB = diff([eps; data.g3])./diff([eps; data.B]);
    end 
    
data.rho2 = data.r2fit./((data.r2fit.^2) + (w./l).*data.r3fit.^2);

end

% Save data for later use
if savedata == 's'
    exportname = split(filename);
    save(['data_' exportname{1} '.mat'],'data')
end 
end

