function [ data ] = transportdata(filename,vsd,do2)

%transportdata - Converts text file from Wu Shi's ACDC aquisition program
%   in a cell-array that contains converted data. This cell array contains
%              - Gate Voltage (V): Gate applied to the device
%              - n (electrons/cm^2): Carrier density of sample based on
%              sample geometry. 
%              - r (ohms): Resistance of channel based on vsd
%              - g (siemens): Conductance of channel based on vsd 

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


dat = csvread(filename,1); 
data = {};

data.gate = dat(:,1); 
data.n = (dat(:,1)).*con.*(eo./ec).*(er1.*er2)./(d1.*er2 + d2.*er1); 
data.g = dat(:,2)./vsd; 
data.r = vsd./dat(:,2);
data.drdv = diff([eps; data.r])./diff([eps; data.gate]);
data.dgdv = diff([eps; data.g])./diff([eps; data.gate]);




   % data.rxx = dat(:,3);
   % data.gxx = 1./data.rxx;
   % data.drxxdv = diff([eps; data.rxx])./diff([eps; data.gate]);
   % data.dgxxdv = diff([eps; data.gxx])./diff([eps; data.gate]); 

    %data.rxy = dat(:,4); 
    %data.gxy = 1./data.rxy; 
    %data.drxydv = diff([eps; data.rxy])./diff([eps; data.gate]);
    %data.dgxydv = diff([eps; data.gxy])./diff([eps; data.gate]);
 
 
end

