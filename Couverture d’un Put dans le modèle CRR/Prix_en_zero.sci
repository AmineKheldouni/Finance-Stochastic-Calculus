clear;
stacksize(10000000);
exec('Constantes.sci');

function [res]=payoff(x,K)
    //put
    res=(K-x).*(x<K);

    //call
    //res=(x-K).*(x>K);
endfunction

// On commence par une version recursive inefficace mais facile a comprendre

function [Y] = Prix_en_zero_rec(N,K,r,a,b,x)
  // Prix du put dans le Modele CRR
  // Noter que ce prix ne depend pas de p

  // on commence par calculer la "proba" p* qui permet d'evaluer  le prix par replication
  p_etoile = (b - r) / (b - a) // proba d'aller en 1+a
  p1 = p_etoile / (1 + r);// proba "actualisee" de choisir 1+a
  p2 = (1 - p_etoile) / (1 + r);// proba "actualisee" de choisir 1+b

  Y = Prix_rec(0,N,K,p1,p2,a,b,x);
endfunction

function[Y]= Prix_rec(n,N,K,p1,p2,a,b,x)
// Version recursive pour verifier
// Prix du put dans le Modele CRR

   if n == N then
	 Y = payoff(x,K);
    else
      p_etoile = (b - r) / (b - a);
      Y = p1 * Prix_rec(n+1,N,K,p1,p2,a,b,x*(1+a)) + p2 * Prix_rec(n+1,N,K,p1,p2,a,b,x*(1+b));
   end
endfunction

//
// Une version iterative (beaucoup) plus efficace mais moins facile a comprendre
//
function [Y] = Prix_en_zero(N,K,r,a,b,x)
  p_etoile = (b - r) / (b - a) // proba d'aller en 1+a
  p1 = p_etoile / (1 + r);// proba de choisir 1+a
  p2 = (1 - p_etoile) / (1 + r);// proba de choisir 1+b

  // xi(i+1) = x(1+a)^(N-i) (1+b)^i
  xi=zeros(1,N+1);
  xi(1) = x * (1+a)^N;
  ro = (1+b) / (1+a);
  for i = 1:N
    xi(i+1) = ro * xi(i);
  end

  // en N : P[i+1] = (x(1+a)^(N-i) (1+b)^i-K)+
  P=zeros(1,N+1);
  for i = 0:N
    P(i+1) = payoff(xi(i+1),K);
  end

  // A un instant j,
  //     P[i+1] approxime P(j,x(1+a)^(N-j-i) (1+b)^i) i=0,...,N-j
  //       i      nbre de choix "up" (1+b) entre j+1 et N
  //       N-j-i  nbre de choix "down" (1+a) entre j+1 et N
  for j = 1:N
    for i = 0:N - j
      P(i+1) =  p1 * P(i+1) + p2 * P(i + 2);
    end
  end
  Y = P(1);
endfunction


//
//Prix par une méthode Monte Carlo
//
function [Y]= SN(M,N,p,a,b,S0)
  V=(rand(M,N)>p);
  W = [zeros(M,1),cumsum(log(1+a)+log((1+b)/(1+a))*V,"c")];
  Z = S0*exp(W);
  Y=Z(:,$);
endfunction

function [prixInf,prixSup]=Prix_MC_en_zero(M,N,K,r,a,b,S0)
    p=(b-r)/(b-a);
    cours=SN(M,N,p,a,b,S0);
    payoffActualise= payoff(cours, K)/(1+r)^N;
    prix=mean(payoffActualise);
    prixInf=prix-1.96*stdev(payoffActualise)/sqrt(M);
    prixSup=prix+1.96*stdev(payoffActualise)/sqrt(M);
endfunction


putEurop=Prix_en_zero(N,K,r,a,b,S0)  // efficace
//res2=Prix_en_zero_rec(N,K,r,a,b,S0) // inefficace, juste pour verifier le prix
[pInfMC,pSupMC]=Prix_MC_en_zero(200000,N,K,r,a,b,S0)

disp(pInfMC);
disp(pSupMC);
