%%----------------------------------------------------%%
%%----- Vahid Jamali
%%----- IRS-Assisted Wireless Communications
%%----------------------------------------------------%%

function [g_irs] =  func_g_IRS_near(Param)

Lx = Param.Lx;
Ly = Param.Ly;
dx = Param.dx;
dy = Param.dy;
lambda = Param.lambda;

p_IRS = Param.p_IRS;
%p_AP = Param.p_AP;
p_obs = Param.p_obs;

IRS_phase = Param.IRS_phase;

gtilde = 4*pi*dy*dx/(lambda^2); % unit-less unit-cell factor

%% g caculation:

[Qx,Qy] = size(IRS_phase);

x_IRS = p_IRS(1)+linspace(-Lx/2,Lx/2,Qx); % position of IRS elements
y_IRS = p_IRS(2)+linspace(-Ly/2,Ly/2,Qy); % position of IRS elements
z_IRS = p_IRS(3);
[xx_IRS,yy_IRS] = meshgrid(x_IRS,y_IRS);

[N,~] = size(p_obs);

%load phase_inc % The incident phase based on the BS-RIS LOS link is fixed and can be computed once, saved, and used later
phase_inc=eye(1,Qy);
phase_inc = phase_inc*0;


R = Lx/2;
r2_local_IRS = (xx_IRS-p_IRS(1)).^2+(yy_IRS-p_IRS(2)).^2;
Index = r2_local_IRS<=R^2;

for ii=1:N

    d_r = sqrt((xx_IRS-p_obs(ii,1)).^2+(yy_IRS-p_obs(ii,2)).^2+(z_IRS - p_obs(ii,3))^2);
    phase_ob = mod(2*pi/lambda*d_r,2*pi); % phase to the observation point
    g_irs(ii) = gtilde*sum(sum(Index.*exp(1j*IRS_phase).*exp(1j*(phase_inc+phase_ob))));

end

end