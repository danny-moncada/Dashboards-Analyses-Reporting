
library(igraph)
E<- rbind(c(1,2,10), c(1,3,5), c(1,4,15), c(2,3,4), c(2,5,9), c(2,6,15), c(3,4,4), c(3,6,8),
          c(4,7,30), c(5,6,15), c(5,8,10), c(6,7,15), c(6,8,10), c(7,3,6), c(7,8,10))


colnames(E)<- c("from", "to", "capacity")
E
g1<- graph_from_data_frame(as.data.frame(E))
g1
max_flow(g1, source=V(g1)["1"], target = V(g1)["8"])#Note this travels from 1 to 8.

plot.igraph(g1)
