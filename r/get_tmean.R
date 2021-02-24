# code to prepare for the process
# the packages need to be installed before running
library(curl)
# library(utils)
library(raster)
library(abind)
if(dir.exists('download'))dir.create('download')

# link to the tmean; change if you want to get others
# website to look at worldclim.org
usl.tavg <- 'http://biogeo.ucdavis.edu/data/worldclim/v2.0/tif/base/wc2.0_2.5m_tavg.zip'
# download and unzip files
curl_download(usl.tavg,'download/tavg.zip',quiet = TRUE)
unzip('download/tavg.zip',exdir = 'download')

# read in the files
t.files <- list.files('download','[.]tif')

temp.ls <- list()
for (i in seq_along(t.files)){
  filename <- paste0('download/',t.files[i])
  
  temp.ra <- raster(filename,xmn=-180, xmx=180, ymn=-90, ymx=90)
  temp.ra <- as.matrix(temp.ra)

  temp.ls[[i]] <- temp.ra[seq((35/180)*nrow(temp.ra),(55/180)*nrow(temp.ra)),
                          seq(((90+180)/360)*ncol(temp.ra), ((130+180)/360)*ncol(temp.ra))]
  
}

tmean.array <- abind(temp.ls,along=3)
# get mean of 12 months
tmean.m <- rowMeans(tmean.array, dims=2)

# get the boundary of mongolia
mog.boundary <- read.table('http://polygons.openstreetmap.fr/get_wkt.py?id=161349&params=0',
                           sep = ',',
                           colClasses = "character")
mog.boundary$V1 <- strsplit(as.character(mog.boundary$V1),'[(]')[[1]][4]

mog.tmp <- apply(mog.boundary,2,function(x)strsplit(x,' ') )

mog.tmp.2 <- lapply(mog.tmp,function(x){c(as.numeric(x[[1]][1]),
                                          as.numeric(x[[1]][2]))})


mg.boundary.df <- do.call(rbind,mog.tmp.2)
mg.boundary.df[is.na(mg.boundary.df)] <- 42.7944874

# make plot
col.func <- colorRampPalette(c('navy','chocolate'))
plot(raster(tmean.m,xmn=90, xmx=130, ymn=35, ymx=55),asp = 0.5,
     xlim=c(90,130),ylim=c(35,55),
     breaks = seq(-20,15,by=5),
     col = col.func(7))

points(mg.boundary.df,type='l',col='white')


