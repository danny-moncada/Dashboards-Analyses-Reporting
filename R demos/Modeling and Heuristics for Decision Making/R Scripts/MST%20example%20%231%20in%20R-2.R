#Minimum Spanning Tree
#Let us load up the igraph package and create a random graph using the Erdos-Renyi model
#and derive the corresponding Minimal Spanning Tree (mst).  

#install.packages(igraph) if you have not already done so :- )
library(igraph)
#here is our vertex/edge code
edges<- read.table(textConnection(
  "from to weight
  1 2 35
  1 3 40
  2 3 35
  2 4 10
  3 4 10
  3 5 15
  4 5 30
  "), header = TRUE)
#Let's take a look :- )
edges

G = graph.data.frame(edges, directed = FALSE)#it is not a directed graph
#
plot(G, asp=1)#asp = 1 means that the aspect ration has been turned on (smaller pic).  
#Let's play with this a bit.
plot(G, asp=5)
plot(G, asp=10)
plot(G, asp=100)
#Let's turn it off :- )
plot(G, asp=0)# asp=0 means the aspect ratio has been turned off
par(mfrow=c(1,2), mar=c(0,1,.75,0))#subplots and margins
mst<- minimum.spanning.tree(G)
plot(G, main="Graph")
plot(mst, main = "MST")
mst

