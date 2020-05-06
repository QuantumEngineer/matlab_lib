function [ data ] = transportdata(filename)
%Imports transport data collected by Wu Shi's ACDC aquisition program. 
%   [ data ] = ztransport(filename) takes in a string which is the filename
%   of the file that needs to be imported. A cell array, data, is returned.
%   The format of this structure array is returned which contains gate (data.gate),
%   carrier density (data.n), conductance (data.g), resistance (data.r). If
%   the data has additional channels it will read up to 2 (data.r1,
%   data.r2).

% Carrier Density Conversion 
eo = 8.854.*10.^(-12); % F/m Electric Constant
er1 = 4; % Dielectric Constant
er2 = 4; 
ec = 1.6021766.*10.^(-19); % C Charge of Electron 
do1 = 285; % nm Dielectric Thickness Oxide
do2 =20; %nm Dielectric Thickness BN 
d1 = do1.*10^(-9);
d2 = do2.*10^(-9);
con = 1./10000; % Nm to meV 
vsd = 37.8;

dat = csvread(filename,1); 
data = {};

data.gate = dat(:,1); 
data.n = (dat(:,1)+1.4).*con.*(eo./ec).*(er1.*er2)./(d1.*er2 + d2.*er1); 
data.nno = 4.*(dat(:,1)+1.4)./vsd;
data.g = dat(:,2)./.00008; 
data.r = .00008./dat(:,2);
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

