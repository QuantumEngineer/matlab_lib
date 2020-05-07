function [ data ] = transportdata(filename,vsd,do2,savedata)

%transportdata - Converts text file from Wu Shi's ACDC aquisition program
%   in a cell-array that contains converted data. This cell array contains
%              - Gate Voltage (V): Gate applied to the device
%              - n (electrons/cm^2): Carrier density of sample based on
%              sample geometry. 
%              - r (ohms): Resistance of channel based on vsd
%              - g (siemens): Conductance of channel based on vsd 

if ~exist('savedata','var')
    % third parameter does not exist, so default it to something
     savedata = 'ds';
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

% Data extraction
dat = csvread(filename,1); 
data = {};

% Check for number of channels
[~, channels] = size(dat);

%Extrac primary channel data 
data.gate = dat(:,1); 
data.n = (dat(:,1)).*con.*(eo./ec).*(er1.*er2)./(d1.*er2 + d2.*er1); 
data.g = dat(:,2)./vsd; 
data.r = vsd./dat(:,2);
data.drdv = diff([eps; data.r])./diff([eps; data.gate]);
data.dgdv = diff([eps; data.g])./diff([eps; data.gate]);

%Extract other channel data

if channels > 2

    data.r2 = dat(:,3);
    data.g2 = 1./data.r2;
    data.dr2dv = diff([eps; data.r2])./diff([eps; data.gate]);
    data.dg2dv = diff([eps; data.g2])./diff([eps; data.gate]); 
    
    if channels > 3
        data.r3 = dat(:,4);
        data.g3 = 1./data.r3;
        data.dr3dv = diff([eps; data.r3])./diff([eps; data.gate]);
        data.dg3dv = diff([eps; data.g3])./diff([eps; data.gate]);
    end 
end

% Save data for later use
if savedata == 's'
    exportname = split(filename);
    save(['data_' exportname{1} '.mat'],'data')
end 
end

