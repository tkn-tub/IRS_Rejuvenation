function [SNRlosriso,SNRriso,SNRlos] = helperRISSimulation(xt,Ncparam,chanlos,chanap2ris,chanris2ue,pos_ap,pos_ris,pos_ue,v,fc,c,SNRref)

lambda = c/fc;
Nr = 10;
dr = 0.5*lambda;
dc = 0.5*lambda;

N0dB = -90;
Nparam = numel(Ncparam);
SNRlosriso = zeros(1,Nparam);
SNRriso = zeros(1,Nparam);
for m = 1:Nparam
release(chanap2ris);
release(chanlos);
release(chanris2ue);

ris = helperRISSurface('Size',[Nr Ncparam(m)],'ElementSpacing',[dr dc],...
    'ReflectorElement',phased.IsotropicAntennaElement,'OperatingFrequency',fc);

[r_ap_ris,ang_ap_ris] = rangeangle(pos_ap,pos_ris);
[r_ue_ris,ang_ue_ris] = rangeangle(pos_ue,pos_ris);

% channel estimation
stv = getSteeringVector(ris);
r_ue_ap = norm(pos_ap-pos_ue);
hd = db2mag(-fspl(r_ue_ap,lambda))*exp(1i*2*pi*r_ue_ap/c);
g = db2mag(-fspl(r_ap_ris,lambda))*exp(1i*2*pi*r_ap_ris/c)*stv(fc,ang_ap_ris);
hr = db2mag(-fspl(r_ue_ris,lambda))*exp(1i*2*pi*r_ue_ris/c)*stv(fc,ang_ue_ris);


rcoeff_losriso = exp(1i*(angle(hd)-angle(hr)-angle(g)));
ylosriso = chanris2ue(ris(chanap2ris(xt,pos_ap,pos_ris,v,v),ang_ap_ris,ang_ue_ris,rcoeff_losriso),pos_ris,pos_ue,v,v)+...
    chanlos(xt,pos_ap,pos_ue,v,v);
SNRlosriso(m) = pow2db(bandpower(ylosriso))-N0dB;

rcoeff_ris = exp(1i*(-angle(hr)-angle(g)));
yriso = chanris2ue(ris(chanap2ris(xt,pos_ap,pos_ris,v,v),ang_ap_ris,ang_ue_ris,rcoeff_ris),pos_ris,pos_ue,v,v);
SNRriso(m) = pow2db(bandpower(yriso))-N0dB;

end

SNRlos = SNRref*ones(1,Nparam);
