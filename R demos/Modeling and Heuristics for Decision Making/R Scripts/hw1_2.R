library(igraph)

c(1, 2, 100)
c(1, 3, 100)
c(1, 4, 100)
c(2, 3, 150)
c(2, 5, 150)
c(3, 4, 120)
c(3, 5, 120)
c(3, 6, 120)

fQP <- function(b) {-sum(c(0,5,0)*b)+0.5*sum(b*b)}
Amat       <- matrix(c(-4,-3,0,2,1,0,0,-2,1), 3, 3)
Amat



bvec       <- c(-8, 2, 0)
constrOptim(c(2,-1,-1), fQP, NULL, ui = t(Amat), ci = bvec)