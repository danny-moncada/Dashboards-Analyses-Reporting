#consider this transportatin problem.
Transport <- data.frame(Leftcolumn = c("origin_a","origin_b","demand"),
cost_dest_1 = c("8", "2", "40"), cost_dest_2 = c("6", "4","35"), 
destination_3= c("3", "9", "25"), capacity = c("70", "40", "Null") )
#Notice that I didn't name the rws but it is easily done by fnishing with
#row.names=c("bla", "bla", "and such"))

Transport

#Let's write and understand *LOL* some of this R code :- )
#defining parameters
#origins run from 1:m where m=2, in this case
#destinations run from 1:j where j=3,  in this case

obj.fun <- c(8, 6, 3, 2, 4, 9)

#recall we wish to minimize the shipping costs 
#8xa1 +6xa2 + 3xa3 + 2xb1 + 4xb2 + 9xb3
(m <- 2)
n <- 3
#build our constraint matrix
constr <- matrix(0, m+n, m*n)
#let's take a look at this
constr
#just an empty matrix for the moment
for(i in 1:m){
  for(j in 1:n){constr[i, n*(i-1) + j] <- 1
                constr[m+j, n*(i-1) +j] <- 1
                }
}
constr

#now look at what this codes variables this codes up

#let's code up the varying equalities

const.dir <- c(rep("<=", m), rep(">=", n))

#the rep tells it is make m coplis like so
const.dir

rhs <- c(70, 40, 40, 35, 25)

#this is the right hand side 
rhs

#Now lets solve this model
library(lpSolve)

prod.trans <- lp("min", obj.fun, constr, const.dir, rhs, compute.sens = TRUE)
lp("min", obj.fun, constr, const.dir, rhs, compute.sens = TRUE)


#here we go :- )
#by thier code first :- )
prod.trans$obj.val

#notice this is probably a typo the is - $obj.val should be $objective or $objval
#lets see :- )
prod.trans$objval
prod.trans$objective



prod.trans$duals.from

prod.trans$duals.to

sol <- matrix(prod.trans$solution, m, n, byrow = TRUE)
sol
lp("min", obj.fun, constr, const.dir, rhs, compute.sens = TRUE)$solution
#recall how our listing went for variables
# a1, a2, a3, b1, b2, b3
#thus the solutions are a2 = 35, a3 = 25, and b1 = 40 : )

#sensitivity analysis of the lp

prod.trans$duals.from
prod.trans$duals.to
prod.trans$sens.coef.from
prod.trans$sens.coef.to

