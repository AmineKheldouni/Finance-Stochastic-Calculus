exec("Prix_Americaines.sci");
exec("S.sci");

function[Y]= CouvertureAmer(n,N,K,r,a,b,x)
  // Couverture dans le Modele CRR
  // Delta(n,x = S_{n-1}) est la quantite a detenir entre n-1 et n

  // Attention : Quantite d'actif risque a detenir entre n-1 et n 
  // Attention : il faut remplacer x par S_{n-1} 
  
  //A COMPLETER
  Y = ????;
endfunction


function [cours_final,valeur_finale]=defaut_de_couvertureAmer(N,K,r,a,b,cours)
  Valeur=zeros(1,N+1);
  Defaut=zeros(1,N+1);

  // A l'instant 0
  S_0 = cours(1);
  V_0 = Prix_en_zero_Amer(N,K,r,a,b,S_0);
  Valeur(1) = V_0;

  // calcul de la couverture entre 0 et 1
  H = CouvertureAmer(1,N,K,r,a,b,S_0);
  SoHo = V_0 - H * S_0; // condition d'autofinancement

  for n=1:N-1
     // on est en n
     S_n = cours(n+1);
	 
     // nouvelle valeur du portefeuille en n
     V = H * S_n + SoHo * (1+r); 
	 
     // calcul de la nouvelle couverture entre n et n+1
     H = CouvertureAmer(n+1,N,K,r,a,b,S_n);
     
     // autofinancement
     //A COMPLETER
     SoHo   = ???;
  
     Valeur(n+1) = V;
     Defaut(n+1) = V-Prix_en_zero_Amer(N-n,K,r,a,b,S_n)
  end;
  // on est en N
  S_N  = cours(N+1);
  V    = H * S_N + SoHo * (1+r);
  res  = V - payoff(cours(N+1),K);

  Valeur(N+1) = V;
  Defaut(N+1) = res;
  
  cours_final = cours;
  valeur_finale = Valeur;
endfunction

p=5;
for i=1:p do
  [cours,valeur] = defaut_de_couvertureAmer(N,K,r,a,b,S(N,0.2,a,b,S0));
  v_payoff=payoff(cours,K);
  CouvertureParfaite=min(valeur-v_payoff)//COMMENTER
end


