#this codes up a top down recursion of the n^th Fibonacci number.  In this case we'll check ther run
#time of several of these computations.

fib <- function(n) {
  if (n<2) 
    return(1)
  
  return (fib(n-1)+fib(n-2))
}
fib(10)
system.time(fib(10))
fib(20)
system.time(fib(20))
fib(30)
system.time(fib(30))

#Here is fib(40)
#fib(40)
#[1] 165580141
#system.time(fib(40))
#user  system elapsed 
#158.10    0.09  158.20

#I didn't want you to have to wait the 2 and 1/2 inutes it took to run*LOL*.

#Here is some nifty code to count the number of calls the computer makes to compute the 
#Fibonacci numbers generated in this recursive mannor.


fib <- function(n) if (n <= 1) 1 else fib(n-1) + fib(n-2)
count.calls <- function(f) {
  force(f)
  function(...) {
    count <<- count+1;
    f(...)
  }
}

with_count <- function(f) {
  force(f)
  function(x) {
    count <<- 0
    c(n=x, result=f(x), calls=count)
  }
}

fib <- count.calls(fib)

t(sapply(1:40, with_count(fib)))
##        n result calls


#Let's meomize!

library(memo)
fib <- memo(fib)
t(sapply(1:16, with_count(fib)))
#Let us see exactly how many calls it took to compute fib(16)
fib <- function(n) if (n <= 1) 1 else fib(n-1) + fib(n-2)
fib <- memo(count.calls(fib))
with_count(fib)(16)
#Here is a nice piece of code to "append" a vector.  We'll use it in a moment
#to get another linear time run for our Fibonacci numbers.
x <- c(0,1)
while (length(x) < 10) {
  position <- length(x)
  new <- x[position] + x[position-1]
  x <- c(x,new)
}
print(x)
#Let's open this up and look inside :- ) 
x <- c(1,2,3,4)
c(x,5)
#It just added the 5 to the end of the c-vector.



#Here is another way to code up the Fibonacci function in a "bottom up" methodology that has a
#a similarly good running time (linear)

Fibonacci <- function(n) {
  x <- c(0,1)
  while (length(x) < n) {
    position <- length(x)
    new <- x[position] + x[position-1]
    x <- c(x,new)
  }
  return(x)
}
Fibonacci(100)
system.time(Fibonacci(100))




