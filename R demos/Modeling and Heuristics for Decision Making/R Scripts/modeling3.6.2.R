## install.packages("lpSolve")

require(lpSolve)

C <- c(30, 40, 80)

A <- matrix(c(1, 1, -10,
              4, 3, -20,
              1, 0, -2,
              1, 1, 0), nrow = 4, byrow = TRUE)

B <- c(500, 200, 100, 1000)

constraints_direction <- c("<=", "<=", "<=", ">=")

optimum <- lp(direction = "min",
              objective.in = C,
              const.mat = A,
              const.dir = constraints_direction,
              const.rhs = B,
              all.int = T)

# Status: 0 = sucess, 2 = no feasible solution
print(optimum$status)

best_Sol <- optimum$solution
best_Sol
names(best_Sol) <- c("x_4p", "x_3p", "x_w")
print(best_Sol)
## ======================================

h1 <- rep(5, 6)
f1 <- rep(10, 6)
s1 <- rep(8, 6)

C <- c(h1, f1, s1)

zeros <- rep(0, 5)

sini <- c(rep(0, 18), 1, zeros)
#sini
sm1 <- c(1, rep(0, 5), -1, zeros, -1, zeros, 1, zeros)
sm1
sm2 <- c(0, 1, zeros, -1, zeros, -1, zeros, 1, zeros)
sm2
sm3 <- c(0, 0, 1, zeros, -1, rep(0, 4), 1, -1, zeros, rep(0, 4))
sm3
sm4 <- c(0, 0, 0, 1, zeros, -1, rep(0, 4), 1, -1, rep(0, 8))
sm4
sm5 <- c(0, 0, 0, 0, 1, zeros, -1, rep(0, 4), )

