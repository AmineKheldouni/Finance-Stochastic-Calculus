exec("S.sci");
exec("Couverture.sci");


function [cours_final,valeur_finale]=defaut_de_couverture(N,K,r,a,b,cours)
  Valeur=zeros(1,N+1);
  Defaut=zeros(1,N+1);

  // A l'instant 0
  S_0 = cours(1);
  V_0 = Prix(0,N,K,r,a,b,S_0);
  Valeur(1) = V_0;

  // calcul de la couverture entre 0 et 1
  H = Couverture(1,N,K,r,a,b,S_0);
  SoHo = V_0 - H * S_0; // condition d'autofinancement

  for n=1:N-1
     // on est en n
     S_n = cours(n+1);

     // nouvelle valeur du portefeuille en n
     //A COMPLETER
     V = H * S_n + SoHo * ???;

     // calcul de la nouvelle couverture entre n et n+1
     H = Couverture(n+1,N,K,r,a,b,S_n);

     // autofinancement
     //A COMPLETER
     SoHo   = ?????;

     Valeur(n+1) = V;
     Defaut(n+1) = V-Prix(n,N,K,r,a,b,S_n)
  end;
  // on est en N
  S_N  = cours(N+1);
  V    = H * S_N + SoHo * (1+r);
  res  = V - payoff(cours(N+1),K);

  Valeur(N+1) = V;
  Defaut(N+1) = res;

  cours_final = cours(N+1);
  valeur_finale = V;
endfunction

q=20;
valeur=zeros(1,q);
cours=zeros(1,q);
v_payoff=zeros(1,q);
for i=1:q do
  [cours(i),valeur(i)] = defaut_de_couverture(N,K,r,a,b,S(N,0.5,a,b,S0));
  v_payoff(i)=payoff(cours(i),K);
end

defautCouverture=norm(v_payoff-valeur)

clf()
plot2d(cours,valeur,style=-1);
