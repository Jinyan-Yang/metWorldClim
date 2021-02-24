world.precip.df <- readRDS('cache/prec.rds')

rainfall.raster <- raster(world.precip.df)
rainfall.raster@extent@xmin <- -90
rainfall.raster@extent@xmax <- 90
rainfall.raster@extent@ymax <- 180
rainfall.raster@extent@ymin <- -180

saveRDS(rainfall.raster,'wc.map.rds')
