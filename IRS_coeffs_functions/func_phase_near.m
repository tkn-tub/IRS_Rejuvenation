%%----------------------------------------------------%%
%%----- Vahid Jamali
%%----- IRS-Assisted Wireless Communications
%%----------------------------------------------------%%

function [IRS_phase] =  func_phase_near(Param)

Ly = Param.Ly;
Lz = Param.Lz;
dy = Param.dy;
dz = Param.dz;

p_IRS = Param.p_IRS;
p_BS = Param.p_BS;
p_focus = Param.p_focus;

Dp_y = Param.Dp_y;
Dp_z = Param.Dp_z;
lambda = Param.lambda;

gtilde = 4*pi*dy*dz/(lambda^2); % unit-less unit-cell factor

%% IRS

L = Ly; % assuming Ly=Lz

d1 = norm(p_BS-p_IRS); % distance from the BS to the IRS
d2 = norm(p_focus-p_IRS); % distance from the IRS to the focus point 

Qy = floor(Ly/dy); % IRS elements
Qz = floor(Lz/dz); % IRS elements

y_IRS = p_IRS(2)+linspace(-Ly/2,Ly/2,Qy); % position of IRS elements
z_IRS = p_IRS(3)+linspace(-Lz/2,Lz/2,Qz); % position of IRS elements
[yy_IRS,zz_IRS] = meshgrid(y_IRS,z_IRS); 

Map_p(:,:,1) = p_focus(1)*ones(Qy,Qz); % x of p_focus extended
Map_p(:,:,2) = p_focus(2)+(yy_IRS-p_IRS(2))/L*Dp_y; % y of p_focus extended
Map_p(:,:,3) = p_focus(3)+(zz_IRS-p_IRS(3))/L*Dp_z; % z of p_focus extended

p_IRS_extended(:,:,1) = ones(Qy,Qz)*p_IRS(1); 
p_IRS_extended(:,:,2) = ones(Qy,Qz)*p_IRS(2); 
p_IRS_extended(:,:,3) = ones(Qy,Qz)*p_IRS(3); 

p_BS_extended(:,:,1) = ones(Qy,Qz)*p_BS(1); 
p_BS_extended(:,:,2) = ones(Qy,Qz)*p_BS(2); 
p_BS_extended(:,:,3) = ones(Qy,Qz)*p_BS(3); 

p_IRSn_extended(:,:,1) = ones(Qy,Qz)*p_IRS(1); 
p_IRSn_extended(:,:,2) = yy_IRS; 
p_IRSn_extended(:,:,3) = zz_IRS; 

Term1 = sqrt(sum((Map_p-p_IRSn_extended).^2,3)); % phase-shifting term
Term2 = sqrt(sum((Map_p-p_IRS_extended).^2,3)); % constant term
Term3 = sqrt(sum((p_BS_extended-p_IRSn_extended).^2,3)); % incident phase cancellation

%load phase_inc % The incident phase based on the BS-RIS LOS link is fixed and can be computed once, saved, and used later
phase_inc=eye(1,Param.Qy);
IRS_phase = -mod(phase_inc+2*pi/lambda*(Term1-Term2),2*pi); % phase to the focus point


end