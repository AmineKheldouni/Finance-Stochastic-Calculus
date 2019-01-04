exec('Prix_en_zero.sci');

function [Y] = Prix_en_zero_Amer(N,K,r,a,b,x)

  p_etoile = (b - r) / (b - a) // proba d'aller en 1+a
  p1 = p_etoile / (1 + r);// proba "actualisee" de choisir 1+a
  p2 = (1 - p_etoile) / (1 + r);// proba "actualisee" de choisir 1+b

  Y = Prix_Amer(0,N,K,p1,p2,a,b,x);
endfunction
  
function[Y]= Prix_Amer(n,N,K,p1,p2,a,b,x)

   if n == N then
	 Y = payoff(x,K);
    else
    //A COMPLETER
	 Y =??????;
   end
endfunction


  putAmer=Prix_en_zero_Amer(N,K,r,a,b,S0)
