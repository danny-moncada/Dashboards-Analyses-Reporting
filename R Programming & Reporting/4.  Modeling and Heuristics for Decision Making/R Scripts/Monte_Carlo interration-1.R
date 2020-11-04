#Let's do some Monte Carlo integration.  Recall, the ave(f) - 1/(b-a) integral f(x)dx on [a, b].
#We'll keep it simple for now :- )
#What is the integral of f(x) = x on [0, 4]. Hopefully you remember it is x^2/2
#evaluated at x = 4 - the evaluation at x = 0. So, this integral is equal to 8.
#Notice that the ave(f) on this interval is 2.  Also notice the (b - a)*ave(f) = 8.
#This is no accident :- )
x<- runif(10, 0, 4)
x
theta.hat<- mean(x)*4
theta.hat
############Pretty poor estimate.
x<- runif(100, 0, 4)
theta.hat<- mean(x)*4
theta.hat
##########################################Better!
x<- runif(1000, 0, 4)
theta.hat<- mean(x)*4
theta.hat
#############################################################Good!
x<- runif(10000, 0, 4)
theta.hat<- mean(x)*4
theta.hat
############
x<- runif(100000, 0, 4)
theta.hat<- mean(x)*4
theta.hat
##########Only off a little!
x<- runif(1000000, 0, 4)#How about one millon!  Still, fast and easy for the computer!
theta.hat<- mean(x)*4
theta.hat
#That's pretty tight *LOL*
pi
#Recall the for N(0,1) the CDF is given by the integral minus infinity to whatever z=?
#Now recall that pretty much befroe z = -10 and after z=10, thus P(z <= -100) = 0
#and P(z <= 100) = 1 (Prett close anyway).  The density function f(x) = 1/(2pi)^.5*e^-(x^2)/2
#is not a function that is easily integrable.  Let's use Monte Carlo
#integration to extimate this.

x<- runif(100000, -100, 100)
theta.hat<- mean(exp(-.5*(x^2)))*200/(sqrt(2*pi))
theta.hat
#Notice that this is about 100% as it should be.  P(z <=0) = .5 would be
x<- runif(100000, -100,0)
theta.hat<- mean(exp(-.5*(x^2)))*100/(sqrt(2*pi))#b-a = 100 here :- )
theta.hat
#######################################################################
x<- runif(100000, 0, pi/4)
theta.hat<- mean(x*sin(x))*pi/4
theta.hat

