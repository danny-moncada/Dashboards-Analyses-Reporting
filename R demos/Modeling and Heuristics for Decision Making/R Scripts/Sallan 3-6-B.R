library(Rglpk)

rows = c('sini', 'sm1','sm2','sm3','sm4','sm5','sm6',
         'hf1','hf2','hf3','fh4','hf5','hf6','hf7','hf8','hf9','hf10')

obj = matrix(c(5,5,5,5,5,5,10,10,10,10,10,10,0,8,8,8,8,8,8,0,0,0,0,0),
             nrow=1, ncol=24, byrow = TRUE)

hires = matrix(c(0,0,0,0,0,0,
                 1,0,0,0,0,0,
                 0,1,0,0,0,0,
                 0,0,1,0,0,0,
                 0,0,0,1,0,0,
                 0,0,0,0,1,0,
                 0,0,0,0,0,1,
                 1,0,0,0,0,0,
                 0,1,0,0,0,0,
                 0,0,1,0,0,0,
                 0,0,0,1,0,0,
                 0,0,0,0,1,0,
                 0,0,0,0,0,0,
                 0,0,0,0,0,0,
                 0,0,0,0,0,0,
                 0,0,0,0,0,0,
                 0,0,0,0,0,0), nrow=17, ncol=6, byrow = TRUE)
colnames(hires) = c('h1','h2','h3','h4','h5','h6')
rownames(hires) = rows
hiretypes = c(rep("I",6))

fires = matrix(c(0,0,0,0,0,0,
                 -1,0,0,0,0,0,
                 0,-1,0,0,0,0,
                 0,0,-1,0,0,0,
                 0,0,0,-1,0,0,
                 0,0,0,0,-1,0,
                 0,0,0,0,0,-1,
                 0,0,0,0,0,0,
                 0,0,0,0,0,0,
                 0,0,0,0,0,0,
                 0,0,0,0,0,0,
                 0,0,0,0,0,0,
                 0,1,0,0,0,0,
                 0,0,1,0,0,0,
                 0,0,0,1,0,0,
                 0,0,0,0,1,0,
                 0,0,0,0,0,1), nrow=17, ncol=6, byrow = TRUE)
colnames(fires) = c('f1','f2','f3','f4','f5','f6')
rownames(fires) = rows
firetypes = c(rep("I",6))

staff = matrix(c(1,0,0,0,0,0,0,
                 1,-1,0,0,0,0,0,
                 0,1,-1,0,0,0,0,
                 0,0,1,-1,0,0,0,
                 0,0,0,1,-1,0,0,
                 0,0,0,0,1,-1,0,
                 0,0,0,0,0,1,-1,
                 0,0,0,0,0,0,0,
                 0,0,0,0,0,0,0,
                 0,0,0,0,0,0,0,
                 0,0,0,0,0,0,0,
                 0,0,0,0,0,0,0,
                 0,0,0,0,0,0,0,
                 0,0,0,0,0,0,0,
                 0,0,0,0,0,0,0,
                 0,0,0,0,0,0,0,
                 0,0,0,0,0,0,0), nrow=17, ncol=7, byrow = TRUE)
colnames(staff) = c('s0','s1','s2','s3','s4','s5','s6')
rownames(staff) = rows
stafftypes = c(rep("I",7))

binaryhire = matrix(c(0,0,0,0,0,
                 0,0,0,0,0,
                 0,0,0,0,0,
                 0,0,0,0,0,
                 0,0,0,0,0,
                 0,0,0,0,0,
                 0,0,0,0,0,
                 -1000,0,0,0,0,
                 0,-1000,0,0,0,
                 0,0,-1000,0,0,
                 0,0,0,-1000,0,
                 0,0,0,0,-1000,
                 1000,0,0,0,0,
                 0,1000,0,0,0,
                 0,0,1000,0,0,
                 0,0,0,1000,0,
                 0,0,0,0,1000), nrow=17, ncol=5, byrow = TRUE)
colnames(binaryhire) = c('b1','b2','b3','b4','b5')
rownames(binaryhire) = rows
binaryhiretypes = c(rep("B",5))

mat = cbind(hires, fires, staff, binaryhire)
types = c(hiretypes, firetypes, stafftypes, binaryhiretypes)

rhs = c(20,0,0,0,0,0,0,0,0,0,0,0,1000,1000,1000,1000,1000)

dir = c('==','==','==','==','==','==','==',
        '<=','<=','<=','<=','<=','<=','<=','<=','<=','<=')

max <- FALSE

bounds <- list(lower = list(ind = c(14L,15L,16L,17L,18L, 19L), 
                            val = c(30,60,55,40,45,50))
               )

Rglpk_solve_LP(obj=obj, mat=mat, dir=dir, rhs=rhs, max=max, bounds=bounds, types=types)
