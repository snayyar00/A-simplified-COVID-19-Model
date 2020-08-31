function dy = eqns(t,y,par,Ro)

alpha = par.alpha;
gamma = par.gamma;
N = par.N;
beta = @(t) Ro(t)*gamma;

% Now others
S = y(1);
E = y(2);
I = y(3);
%R = y(4);

dy = zeros(4,1);
dy(1) = -beta(t)*S*I/N;
dy(2) = beta(t)*S*I/N - alpha*E;
dy(3) = alpha*E - gamma*I;
dy(4) = gamma*I;

end