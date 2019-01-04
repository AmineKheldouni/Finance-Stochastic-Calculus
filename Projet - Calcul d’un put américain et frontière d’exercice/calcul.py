from sympy import *

from numpy import *
import matplotlib.pyplot as plt


class ApproxFrontier:
    def __init__(self):
        #Constantes
        self.sigma = 0.05
        self.r = 0.08
        self.mu = 0.1
        self.s0 = 20
        self.K = 1.1*self.s0
        self.T =0.5

    def N(self, x):
        """fonction de répartition de la loi normale centrée réduite
           (= probabilité qu'une variable aléatoire distribuée selon
           cette loi soit inférieure à x)
           formule simplifiée proposée par Abramovitz & Stegun dans le livre
           "Handbook of Mathematical Functions" (erreur < 7.5e-8)
        """
        u = abs(x) # car la formule n'est valable que pour x>=0

        Z = 1/(sqrt(2*pi))*exp(-u*u/2) # ordonnée de la LNCR pour l'absisse u

        b1 = 0.319381530
        b2 = -0.356563782
        b3 = 1.781477937
        b4 = -1.821255978
        b5 = 1.330274429

        t = 1/(1+0.2316419*u)
        t2 = t*t
        t4 = t2*t2

        P = 1-Z*(b1*t + b2*t2 + b3*t2*t + b4*t4 + b5*t4*t)
        if x < 0:
            P = 1.0-P # traitement des valeurs x<0

        return P

    def gaussian(self, x):
        return 1/sqrt(2*pi) * exp(-x**2/2)

    def b1(self, a):
        return self.sigma/2 + a/self.sigma

    def b2(self, A):
        return log(A/self.s0)/self.sigma

    def b3(self, a):
        return sqrt(self.b1(a)**2 + 2*self.r)

    def f(self, A,a,t):
        b_1 = self.b1(a)
        b_2 = self.b2(A)
        b_3 = self.b3(a)
        t1 = -exp(-self.r*t)*self.N(b_1*sqrt(t)+ b_2/(sqrt(t)))
        t2 = (1/2)*(b_1/b_3 +1)*exp( b_2*(b_3-b_1))*self.N(b_3*sqrt(t) \
        + b_2/sqrt(t) )
        t3 = (1/2)*(b_1/b_3 -1)*exp(-b_2*(b_1+b_3))*self.N(b_3*sqrt(t) - \
        b_2/sqrt(t) )
        return t1+t2+t3

    def df_dx(self, A,a,t):
        b_1 = self.b1(a)
        b_2 = self.b2(A)
        b_3 = self.b3(a)
        db2 = 1/(self.sigma*A)
        t1 = -exp(-self.r*t)/sqrt(t) * self.gaussian(b_1*sqrt(t)+b_2/sqrt(t))
        t2 = 1/2 * (b_1/b_3 + 1) * exp(b_2*(b_3-b_1)) * ((b_3-b_1) * \
        self.N(b_3*sqrt(t)+b_2/sqrt(t))+1/sqrt(t) * \
        self.gaussian(b_3*sqrt(t)+b_2/sqrt(t)))
        t3 = 1/2 * (b_1/b_3 - 1) * exp(-b_2*(b_3+b_1)) * (-(b_3+b_1) * \
        self.N(b_3*sqrt(t)-b_2/sqrt(t))-1/sqrt(t) * \
        self.gaussian(b_3*sqrt(t)-b_2/sqrt(t)))
        return (t1+t2+t3)*db2


    def d1(self, t):
        return ( log(self.s0/self.K)+ t*(self.r+self.sigma**2/2) )/\
        self.sigma*sqrt(t)

    def d2(self, t):
        return self.d1(t) - self.sigma*sqrt(t)

    def P(self, X,t):
        dd2 = self.d2(t)
        dd1 = self.d1(t)
        return -X * self.N(-dd1) + self.K * exp(-self.r*t) * self.N(-dd2)

    def dP0(self,X):
        dd2 = self.d2(0.00001)
        dd1 = self.d1(0.00001)
        return -self.N(-dd1)+X/(X*self.sigma*sqrt(self.T))*self.N(-dd1) + \
        self.K*exp(-self.r*0)*self.N(-dd2)

    def u_dx(self,A,a):
        return self.dput(A) + self.K * self.df_dx(A,a,self.T) - \
        self.K*self.df_dx(A,a,0.00001)

    def u(self,A,a):
        res = self.put(A) + self.K*(self.f(A,a,self.T) -self.f(A,a,0.00001))
        return res


    def put(self, A):
        if A > self.K:
            return 0
        else:
            return (self.K-A)

    def dput(self, A):
        if A > self.K:
            return 0
        else:
            return -1

    def u_optimize(self, A, a):
        return self.u(A,a) - self.put(A)

    def du_optimize(self, A, a):
        return self.u_dx(A,a) - self.dput(A)

    def solver(self):
        A = Symbol('A')
        a = Symbol('a')
        nsolve((u_optimize,du_optimize), (A,a), (20, 0.5))


M = ApproxFrontier()

A = 16.6033
print("Prix du put americain :")
print(M.K-A)
a = 0.210308108108
print("Test valeur de l'approximation de Ju : ")
print(M.u(A,a))
print("Valeur de la dérivée en (A,a) :")
print(M.u_dx(A,a))
print("###############")
print(M.u(A,a)-(M.K-A))
a = 0.210308108108

# A = linspace(9,200,5000)
# #a = linspace(0.7,10,1000)
# Yu = [M.u_optimize(x,a) for x in A]
# Yud = [M.du_optimize(x,a) for x in A]
# plt.plot(A,Yu)
# plt.plot(A,Yud)
# plt.show()

"""
A = Symbol('A', real=True)
a = Symbol('a', real=True)
result = nsolve((M.u_optimize(A,a), M.du_optimize(A,a)), (A, a), (1, 1))
"""
