library(RColorBrewer)
library(dplyr)
library(sp)

source(file= "fun.R")


url.grid <- "http://www.europeanwindstorms.org/database/dataDesc/grid_locations.csv"
url.repo.names <- "http://www.europeanwindstorms.org/repository/"
url.repo <- "http://www.europeanwindstorms.org/repository/"

# simple xws app

en <- getXWSEventNames(url.repo.names)
fp <- getFootPrint(url.repo, en[1], c("gid","ws"), "ws")
grid <- getXWSGRID(url.grid)

# preprocessing

x.sp <- SpatialPoints(grid[,c("x","y")])
x.spdf <- SpatialPointsDataFrame(x.sp, grid)

e <- cbind(grid,fp)
e[,"ws.intensity"] <- cut(e[,"ws"], breaks = c(0,15,20,25,30,35,40,45,50,100) ) %>% 
                      as.integer()

#head(e)
#table(e$ws.intensity)

# visualize

b <- bbox(x.sp)
b["x","min"] <- -5
b["x","max"] <- 15
b["y","min"] <- 50
b["y","max"] <- 60

plot(x.spdf, add = F, col = 1, lwd = 0.3, cex = 0.2,
     xlim = c( b["x","min"], b["x","max"]), 
     ylim = c(b["y","min"], b["y","max"]), axes = T)

#display.brewer.all()
cols <- brewer.pal(9, "YlOrRd")

points(x = e[,c("x")], y = e[,c("y")],  pch = 21,
       lwd = 1, 
       cex = 0.5, 
       bg = cols[e[,"ws.intensity"]],
       col = cols[e[,"ws.intensity"]])





