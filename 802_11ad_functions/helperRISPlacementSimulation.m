function SNRris = helperRISPlacementSimulation(xt,drparam,ris,chanlos,chanap2ris,chanris2ue,pos_ap,pos_ue,v,fc,c)

lambda = c/fc;
stv = getSteeringVector(ris);
N0dB = -90;
Nparam = numel(drparam);
SNRris = zeros(1,Nparam);
for m = 1:Nparam
release(chanap2ris);
release(chanlos);
release(chanris2ue);

pos_ris = [drparam(m);0;0];

[r_ap_ris,ang_ap_ris] = rangeangle(pos_ap,pos_ris);
[r_ue_ris,ang_ue_ris] = rangeangle(pos_ue,pos_ris);

% channel estimation
g = db2mag(-fspl(r_ap_ris,lambda))*exp(1i*2*pi*r_ap_ris/c)*stv(fc,ang_ap_ris);
hr = db2mag(-fspl(r_ue_ris,lambda))*exp(1i*2*pi*r_ue_ris/c)*stv(fc,ang_ue_ris);

rcoeff_ris = exp(1i*(-angle(hr)-angle(g)));
yriso = chanris2ue(ris(chanap2ris(xt,pos_ap,pos_ris,v,v),ang_ap_ris,ang_ue_ris,rcoeff_ris),pos_ris,pos_ue,v,v);
SNRris(m) = pow2db(bandpower(yriso))-N0dB;
end