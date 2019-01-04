exec('Constantes.sci');


function [Y]= S(N,p,a,b,S0)
  // V vaut 0 si T=1+a avec proba p
  //   vaut 1 si T=1+b avec proba 1-p
  V=(rand(1,N)>p);
  W = [0,cumsum(log(1+a)+log((1+b)/(1+a))*V)];
  Y = S0*exp(W)
endfunction

//Exemples de trajectoires
p=0.1;
traj=S(N,p,a,b,S0);
plot2d(0:N,traj,-1,rect=[0,S0*(1+a)^N,N+0.5,S0*(1+b)^N],nax=[0,-1,0,-1]);

p=0.5;
traj=S(N,p,a,b,S0);
plot2d(0:N,traj,-2,rect=[0,S0*(1+a)^N,N+0.5,S0*(1+b)^N],nax=[0,-1,0,-1]);

p=0.9;
traj=S(N,p,a,b,S0);
plot2d(0:N,traj,-3,rect=[0,S0*(1+a)^N,N+0.5,S0*(1+b)^N],nax=[0,-1,0,-1]);
legends(["Trajectoire p=0.1";"Trajectoire p=0.5";"Trajectoire p=0.9"],[-1,-2,-3], opt=2)
