usl.tavg <- 'http://biogeo.ucdavis.edu/data/worldclim/v2.0/tif/base/wc2.0_10m_tmax.zip'
# download and unzip files
curl_download(usl.tavg,'download/tavg.zip',quiet = TRUE)
unzip('download/tavg.zip',exdir = 'download')

library(curl)
library(raster)
library(abind)
var.vec <- c('prec',
             'srad',
             'vapr',
             'tmax')

for (var.in in var.vec){
  usl.tavg <- sprintf('http://biogeo.ucdavis.edu/data/worldclim/v2.0/tif/base/wc2.0_10m_%s.zip',var.in)
  
  fn <- sprintf('download/%s.zip',var.in)
 
  if(!file.exists(fn)){
    curl_download(usl.tavg,fn,quiet = TRUE)
    unzip(fn,exdir = sprintf('download/%s',var.in))
    }
  
  if(var.in %in% c('prec',
                   'srad',
                   'tmax')){
    # read in the files
    t.files <- list.files(sprintf('download/%s',var.in),'[.]tif')
    
    temp.ls <- list()
    for (i in seq_along(t.files)){
      filename <- paste0('download/',var.in,'/',t.files[i])
      
      temp.ra <- raster(filename)
      
      temp.ls[[i]] <- as.matrix(temp.ra)
      
    }
    
    tmean.array <- abind(temp.ls,along=3)
    # get mean of 12 months
    tmean.m <- rowMeans(tmean.array, dims=2)
    
    saveRDS(tmean.m,sprintf('cache/%s.rds',var.in))
  }
}
# plot(raster(tmean.m))
# 

# read in the files
t.files <- list.files(sprintf('download/%s','tmax'),'[.]tif')
vp.files <- list.files(sprintf('download/%s','vapr'),'[.]tif')
temp.ls <- list()
for (i in seq_along(t.files)){
  filename.t <- paste0('download/tmax/',t.files[i])
  filename.vp <- paste0('download/vapr/',vp.files[i])
  
  temp.t <- raster(filename.t)
  temp.vp <- raster(filename.vp)
  
  vpd.m <- (0.6108 * exp(17.27 * temp.t / (temp.t + 237.3))) / temp.vp
  
  temp.ls[[i]] <- as.matrix(vpd.m)
  
}

vpd.array <- abind(temp.ls,along=3)
# get mean of 12 months
vpd.mean <- rowMeans(vpd.array, dims=2)

vpd.mean[vpd.mean > 5] <- NA
# plot(raster(vpd.mean))
saveRDS(vpd.mean,'cache/vpd.rds')


