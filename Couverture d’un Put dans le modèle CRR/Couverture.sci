exec('Prix.sci');

function[Y]= Couverture(n,N,K,r,a,b,x)
  // Couverture dans le Modele CRR
  // Delta(n,x = S_{n-1}) est la quantite a detenir entre n-1 et n
  Y = (Prix(n,N,K,r,a,b,x*(1+a))-Prix(n,N,K,r,a,b,x*(1+b))) / (x*(b-a));
endfunction
