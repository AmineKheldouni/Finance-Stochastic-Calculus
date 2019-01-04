
S0=100;              // prix a l'instant 0
K=100;               // valeur d'exercice (strike)

N = 10;             // nbre de pas de discretisation

T=4.0/12.0;         // date d'echeance en annÃ©e
Dt = T/N;           // pas de temps

R=0.02;     // taux sans risque annuel
r = exp(R * Dt)-1;   // taux de rendement sur la periode

// le choix de up et down est liÃ© a la discretisation
// du modele de black et Scholes que l'on verra dans la 2Ã¨me partie du cours

sigma=0.2;          // volatilite de l'actif dans
                    // le modele de Black et Scholes

// 1+a < 1 + r < 1 + b
a = (1+r) * exp(- sigma * sqrt(Dt)) - 1;      // etat "down"
b = (1+r) * exp(+ sigma * sqrt(Dt)) - 1;      // etat "up"
