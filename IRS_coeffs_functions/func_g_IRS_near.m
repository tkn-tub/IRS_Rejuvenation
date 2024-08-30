%%----------------------------------------------------%%
%%----- Vahid Jamali
%%----- IRS-Assisted Wireless Communications
%%----------------------------------------------------%%

function [g_irs] =  func_g_IRS_near(Param)

Ly = Param.Ly;
Lz = Param.Lz;
dy = Param.dy;
dz = Param.dz;
lambda = Param.lambda;

p_IRS = Param.p_IRS;
p_BS = Param.p_BS;
p_obs = Param.p_obs;

IRS_phase = Param.IRS_phase;

gtilde = 4*pi*dy*dz/(lambda^2); % unit-less unit-cell factor

%% g caculation:

[Qy,Qz] = size(IRS_phase);

y_IRS = p_IRS(2)+linspace(-Ly/2,Ly/2,Qy); % position of IRS elements
z_IRS = p_IRS(3)+linspace(-Lz/2,Lz/2,Qz); % position of IRS elements
[yy_IRS,zz_IRS] = meshgrid(y_IRS,z_IRS);

[N,~] = size(p_obs);

% load phase_inc % The incident phase based on the BS-RIS LOS link is fixed and can be computed once, saved, and used later
phase_inc=eye(1,Param.Qy);

for ii=1:N

    d_r = sqrt((p_obs(ii,1))^2+(yy_IRS-p_obs(ii,2)).^2+(zz_IRS-p_obs(ii,3)).^2);
    phase_ob = mod(2*pi/lambda*d_r,2*pi); % phase to the observation point
    g_irs(ii) = gtilde*sum(sum(exp(1j*IRS_phase).*exp(1j*(phase_inc+phase_ob))));

end

end