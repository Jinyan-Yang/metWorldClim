library("g1.opt.func")


prec.m <- readRDS(url("https://github.com/Jinyan-Yang/metWorldClim/raw/master/cache/prec.rds"))
prec.yr.m <- prec.m * 12
prec.yr.m[prec.yr.m > 2000] <- NA
prec.yr.m[prec.yr.m < 100] <- NA
tmax.m <- readRDS(url("https://github.com/Jinyan-Yang/metWorldClim/raw/master/cache/tmax.rds"))
tmax.m[tmax.m < 10] <- NA
srad.m <- readRDS(url("https://github.com/Jinyan-Yang/metWorldClim/raw/master/cache/srad.rds"))
srad.yr.m <- srad.m * 365.25 * 10^-3 * 0.5
vpd.m <- readRDS(url("https://github.com/Jinyan-Yang/metWorldClim/raw/master/cache/vpd.rds"))

na.index <- which(is.na(tmax.m))
prec.yr.m[na.index] <- NA
vpd.m[na.index] <- NA
srad.yr.m[na.index] <- NA
range(srad.yr.m,na.rm = T)
range(vpd.m,na.rm = T)
range(tmax.m,na.rm = T)
range(prec.yr.m,na.rm = T)

library(raster)
plot(raster(prec.yr.m))
plot(raster(tmax.m))
plot(raster(srad.yr.m))
plot(raster(vpd.m))

# file.Name <- c("g1", "LAI","Gs","NCG","LUE","GPP")
out.m <- mapply(g1.lai.e.func,
                VPD = as.vector(vpd.m),
                E = as.vector(prec.yr.m),
                PAR = as.vector(srad.yr.m), 
                TMAX = as.vector(tmax.m))

out.lai <- matrix(out.m[2,],
                  ncol = ncol(vpd.m),
                  nrow = nrow(vpd.m))

out.g1 <- matrix(out.m[1,],
                  ncol = ncol(vpd.m),
                  nrow = nrow(vpd.m))

# out.lai[out.lai>12] <- NA
# out.lai[out.lai<0] <- NA
# max(out.lai,na.rm=T)
plot(raster(out.lai))
plot(raster(out.g1))
# vpd.m[300,600]
# ncol(vpd.m)
# 
# tmax.m[300,600]
# prec.yr.m[300,600]
# srad.yr.m[300,600]

g1.lai.e.func(PAR = 1500,VPD = 2,TMAX = 10,E = 100)

g1.lai.e.func(PAR = srad.yr.m[300,600],
              VPD = vpd.m[300,600],
              TMAX = tmax.m[300,600],
              E = prec.yr.m[300,600])

out.lai[300,600]

# out.g1 <- readRDS('cache/g1.opt.rds')
# out.lai <- readRDS('cache/lai.opt.rds')
saveRDS(out.g1,'cache/g1.opt.rds')
saveRDS(out.lai,'cache/lai.opt.rds')
