#Knapsack Example 1 from package "adagio" page 12 only pick one of each :- ) 
library(adagio)
#Arguments 
#w = integer vector of weights
#p = integer vector of profits
#cap = maximal capacitcy of knapsack, integer too
p<- c(15,100,90,60,40,15,10,1)
p
w<- c(2,20,20,30,40,30,60,10)
w
cap<- 102
cap
(is<- knapsack(w,p,cap))
#let us see this as a straight up lp problem in both lpSolve and Rgplk
#notice the different ways they code up the binary variables
library(lpSolve)
library(Rglpk)
#here the variables might be calles p1,p2,p3,p4,p5,p6,p7,p8
#and we want to maximize 15*x1 + 100*x2 + 90*x3 + 60*x4 + 40*x5 + 15*x6 + 10*x7 + 1*x8
#subject to 2x1 + 20x2 + 20x3 + 30x4 + 40x5 + 30x6 + 60x7 + 1x8 <= 102 (the cap)
f.obj<- c(15,100,90,60,40,15,10,1)
f.obj
f.con <- matrix(c(2,20,20,30,40,30,60,1), ncol=8, byrow=T)
f.con
f.dir<- c("<=")
f.dir
types<- c(rep("B",8))
types
f.rhs<- c(102)
lp("max", f.obj, f.con, f.dir, f.rhs, all.bin = T)#all.bin = T
lp("max", f.obj, f.con, f.dir, f.rhs, all.bin = T)$solution
lp_f.obj<- Rglpk_solve_LP(f.obj, f.con, f.dir, f.rhs, max=TRUE, types=types)#types = types
lp_f.obj

