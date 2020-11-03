
#Maxflow Example 1



library(igraph)
E<- rbind(c(1,3,3), c(3,4,1), c(4,2,2), c(1,5,1), c(5,6,2), c(6,2,10))
#This codes the edges up in the order you put them in, not by vertex :- )
E
colnames(E)<- c("from", "to", "capacity")
E
g1<- graph_from_data_frame(as.data.frame(E))
g1

max_flow(g1, source=V(g1)["1"], target = V(g1)["2"])#Note this travels from 1 to 2.

plot.igraph(g1)


  
