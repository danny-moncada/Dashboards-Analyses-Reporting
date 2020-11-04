library(boot)

pop_mean = 60
data <- rnorm(15,pop_mean,3)
#data<-sample(x,15,replace = F)
data
mean(data)

mu.boot<- function(data,i){
  y<- data[i]
  mean(y)
}

boot.obj<- boot(data, statistic = mu.boot, R= 2000)
print(boot.obj)  #mean is "original"

#Bootstrap estimate of mean
mu<- replicate(2000, expr= {
  k<- sample(data,size = 10, replace = T)
  
      mean(k) })
print(mean(mu))

mean_estimate = quantile(mu, .5)
((mean_estimate - pop_mean)/pop_mean)*100


