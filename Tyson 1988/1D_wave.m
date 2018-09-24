% Tyson 1988 three component model. 1D wave
clear all, clc, close all
% Some parameters based on Table 2, parameter set A
L1=10; L2=0.005; kappa=18.5; c=10;  
lambda1=1e-4; % 1e-3;
lambda2=0.26; %2.4; 
s1=690;% 950; 
s2=0.033;% 0.05; 
epsilon_prime=0.014; % 0.0182 ;  
D=0.024; % mm2/min
kt=0.9; % 3.0;
ke=5.4; % 12;
k1=0.036; %0.12; 
k_1=0.36; % 1.2;
k2=0.666;% 2.22;
k_2=0.0033;% 0.011;
h=5;

% Initializations
X=0:0.045:9; %% length of observation 9mm 
X=
numofgrids=length(X);
step=X(2)-X(1);
% Time step size
dt = 0.12;
% Time vector
t= 0:dt:50;

% Initializing gamma beta and rho
rho = 0.1.*ones(1,numofgrids);
beta = zeros(1,numofgrids); beta(1:3)=100.*ones(1,3); % initial intracellular cAMP pulse 
gamma = zeros(1,numofgrids);

f1 = figure(1)
subplot(2,2,1)
plot(X,rho);
title('Initial condition of rho','FontSize', 11, 'FontWeight', 'bold')
subplot(2,2,2)        
plot(X,beta)
title('Initial condition of beta','FontSize', 11, 'FontWeight', 'bold')
subplot(2,2,3)        
plot(X,gamma)
title('Initial condition of gamma','FontSize', 11, 'FontWeight', 'bold')
movegui(f1,'northwest')

% Starting simulation

f1gamma=@(gamma,rho) (1+kappa.*gamma)./(1+gamma);
f2gamma=@(gamma,rho) (L1+kappa.*L2.*c.*gamma)./(1+c.*gamma);
phi=@(gamma,rho) (lambda1+(rho.*gamma./(1+gamma)).^2)./(lambda2+(rho.*gamma./(1+gamma)).^2);
for i = 1:1:length(t)
   L=4*del2(gamma,step); % Laplacian
   rho_new= rho+dt.*k1.*(-f1gamma(gamma,rho).*rho+f2gamma(gamma,rho).*(ones(1,numofgrids)-rho));
   beta_new= beta+dt.*k1./epsilon_prime.*(s1.*phi(gamma,rho)-beta);
   gamma_new = gamma+dt.*(kt./h.*beta-ke.*gamma+D.*L);
   rho=rho_new;
   beta=beta_new;
   gamma=gamma_new;
   % periodic boundary condition: is this correct?
   rho(end)=rho(1);beta(end)=beta(1);
   gamma(end)=gamma(1);
   
   % Plot in real time 
   if (0 == mod(i,1) )       
       f2 = figure(2);
%        subplot(2,2,1) 
       plot(X,rho)
       ylim([0 1])
       xlabel('mm')
       ylabel('rho: active receptor ratio')
       title(['Active receptor ratio at time point #: ', num2str(i)])
   end
%        subplot(2,2,2)
%        plot(X,beta)
%        xlabel('mm')
%        ylabel('beta: intracellular cAMP')
%        title(['Intracellular cAMP at time point #: ', num2str(i)])
%        
%        subplot(2,2,3)
%        plot(X,gamma)
%        xlabel('mm')
%        ylabel('gamma: extracellular cAMP')
%        title(['Extracellular cAMP at time point #: ', num2str(i)])
       
% % scatter out the time trace of the j-th point
%        j=3;
%        plot(t(i),rho(j),'.')
%        ylim([0 1])
%        hold on
%         pause(0.06)
%    end
   
   % Adding some extra perturbation
%    if ( i<200 && add_extra )       
%        gamma(y1:(y2-2),x1:(x2-1))=10.*ones((l-1),(w));     
%    end
 
   % Displaying elapsed time units
   clc; disp('Time: '); disp(t(i))      
end