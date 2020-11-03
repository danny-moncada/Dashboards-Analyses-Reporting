
#Maxflow Example 2


library(igraph)
E<- rbind(c(1,2,2), c(1,3,3), c(3,2,1), c(3,5,4), c(3,4,3), c(2,5,2), c(4,6,2), c(5,6,2))
# Each c(a,b,c) codes its position for the $cut[1]  

colnames(E)<- c("from", "to", "capacity")
E
g1<- graph_from_data_frame(as.data.frame(E))
g1
max_flow(g1, source=V(g1)["1"], target = V(g1)["6"])

plot.igraph(g1)
#$cut[1] 7 8 means we're taking out the 7^th and 8^th positon in E
# That is cut position 7 which is c(4,6,2) and position 8 which is c(5,6,2)


