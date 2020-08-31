%% Main Script
clc; clear;

% Variables that won't change
N = 5e6; % 5 million
par.alpha = 1/5.2;
par.gamma = 1/10;
par.N = N;

% Scenario 1
R = @(t) 3.5;

Tfinal = 180;

% Initial Conditions
Io = 40;
Eo = 20*Io;
Ro = 0;
So = N-Io-Eo-Ro;
inits = [So;Eo;Io;Ro];

% Now ode45
[t,y] = ode45(@(t,y) eqns(t,y,par,R),[0 Tfinal],inits);

% Plotting
subplot(411)
plot(t,y(:,1),'LineWidth',1.2)
xlabel('Time [days]'); ylabel('Population'); grid on;
title('Susceptible Individuals')

subplot(412)
plot(t,y(:,2),'LineWidth',1.2)
xlabel('Time [days]'); ylabel('Population'); grid on;
title('Exposed Individuals')

subplot(413)
plot(t,y(:,3),'LineWidth',1.2)
xlabel('Time [days]'); ylabel('Population'); grid on;
title('Infected Individuals')

subplot(414)
plot(t,y(:,4),'LineWidth',1.2)
xlabel('Time [days]'); ylabel('Population'); grid on;
title('Removed Individuals')
sgtitle('Scenario 1 - Constant R_o')

% Scenario 2
R = @(t) lockdown(t);
% Now ode function
[t2, y2] = ode45(@(t,y) eqns(t,y,par,R),[0 Tfinal],inits);

figure(2)
subplot(411)
plot(t2,y2(:,1),'LineWidth',1.2)
xlabel('Time [days]'); ylabel('Population'); grid on;
title('Susceptible Individuals')

subplot(412)
plot(t2,y2(:,2),'LineWidth',1.2)
xlabel('Time [days]'); ylabel('Population'); grid on;
title('Exposed Individuals')

subplot(413)
plot(t2,y2(:,3),'LineWidth',1.2)
xlabel('Time [days]'); ylabel('Population'); grid on;
title('Infected Individuals')

subplot(414)
plot(t2,y2(:,4),'LineWidth',1.2)
xlabel('Time [days]'); ylabel('Population'); grid on;
title('Removed Individuals')
sgtitle('Scenario 2 - Lockdown Measures')

% Scenario 3
R = @(t) effective(t);
% Now ode function
[t3, y3] = ode45(@(t,y) eqns(t,y,par,R),[0 Tfinal],inits);

figure(3)
subplot(411)
plot(t3,y3(:,1),'LineWidth',1.2)
xlabel('Time [days]'); ylabel('Population'); grid on;
title('Susceptible Individuals')

subplot(412)
plot(t3,y3(:,2),'LineWidth',1.2)
xlabel('Time [days]'); ylabel('Population'); grid on;
title('Exposed Individuals')

subplot(413)
plot(t3,y3(:,3),'LineWidth',1.2)
xlabel('Time [days]'); ylabel('Population'); grid on;
title('Infected Individuals')

subplot(414)
plot(t3,y3(:,4),'LineWidth',1.2)
xlabel('Time [days]'); ylabel('Population'); grid on;
title('Removed Individuals')
sgtitle('Scenario 3 - Effective Measures')

% Scenario 4
R = @(t) prevention(t);
% Now ode function
[t4, y4] = ode45(@(t,y) eqns(t,y,par,R),[0 Tfinal],inits);

figure(4)
subplot(411)
plot(t4,y4(:,1),'LineWidth',1.2)
xlabel('Time [days]'); ylabel('Population'); grid on;
title('Susceptible Individuals')

subplot(412)
plot(t4,y4(:,2),'LineWidth',1.2)
xlabel('Time [days]'); ylabel('Population'); grid on;
title('Exposed Individuals')

subplot(413)
plot(t4,y4(:,3),'LineWidth',1.2)
xlabel('Time [days]'); ylabel('Population'); grid on;
title('Infected Individuals')

subplot(414)
plot(t4,y4(:,4),'LineWidth',1.2)
xlabel('Time [days]'); ylabel('Population'); grid on;
title('Removed Individuals')
sgtitle('Scenario 4 - Preventive Measures')

% Now comparing deaths
deaths = zeros(1,4);
Rec = {y(:,4) y2(:,4) y3(:,4) y4(:,4)};

for i = 1:4
    Rs = Rec{i};
    n = length(Rs);
    d = 0; % Initial death is 0
    for j = 1:n
        d = d + 0.04*Rs(j);
    end
    deaths(i) = d / 1e6;
end

% Total cases and active cases
% Gettings terms
ActiveCases = {y(:,3)+y(:,2) y2(:,3)+y2(:,2) y3(:,3)+y3(:,2)...
    y4(:,3)+y4(:,2)};
           
% Now total cases
totalCases = {cumtrapz(ActiveCases{1}) cumtrapz(ActiveCases{2}) ...
    cumtrapz(ActiveCases{3}) cumtrapz(ActiveCases{4})};

% Now plotting
figure(5); 
subplot(211); hold on; 
plot(t,ActiveCases{1},'LineWidth',1.2,'DisplayName','Scenario 1')
plot(t2,ActiveCases{2},'LineWidth',1.2,'DisplayName','Scenario 2')
plot(t3,ActiveCases{3},'LineWidth',1.2,'DisplayName','Scenario 3')
plot(t4,ActiveCases{4},'LineWidth',1.2,'DisplayName','Scenario 4')
legend show
grid on; xlabel('Time [days]'); ylabel('Population'); title('Active Cases')

subplot(212); hold on; 
plot(t,totalCases{1},'LineWidth',1.2,'DisplayName','Scenario 1')
plot(t2,totalCases{2},'LineWidth',1.2,'DisplayName','Scenario 2')
plot(t3,totalCases{3},'LineWidth',1.2,'DisplayName','Scenario 3')
plot(t4,totalCases{4},'LineWidth',1.2,'DisplayName','Scenario 4')
legend('show','Location','NW')
grid on; xlabel('Time [days]'); ylabel('Population'); title('Total Cases')

% Infected Patients
In = {y(:,3) y2(:,3) y3(:,3) y4(:,3)};
ts = {t t2 t3 t4};
scen = {'Scenario 1','Scenario 2','Scenario 3','Scenario 4'};
figure(6)
subplot(211);
plot([0 180],[3500 3500],'LineWidth',1,'DisplayName','Capacity')
grid on; title('Hospitalized People'); xlabel('Time [days]')
ylabel('Population')
hold on;
subplot(212); 
plot([0 180],[160 160],'LineWidth',1,'DisplayName','Capacity')
grid on; title('People on ICU'); xlabel('Time [days]')
ylabel('Population')
hold on;
for i = 1:4
    Is = In{i};
    host = 0.08*Is;
    ic = 0.01*Is;
    host(host>3500) = 3500;
    ic(ic>160) = 160;
    subplot(211)
    plot(ts{i},host,'DisplayName',scen{i},'LineWidth',1)
    subplot(212)
    plot(ts{i},ic,'DisplayName',scen{i},'LineWidth',1)
end
subplot(211)
legend('show','location','best')
subplot(212)
legend('show','location','best')