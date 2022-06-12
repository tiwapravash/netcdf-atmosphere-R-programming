####netcdf to csv#######
###Contact me : tiwarip@cumt.edu.cn###

rm(list=ls(all=TRUE))
library(ncdf4)    #####Load netcdf libarary #######
library(lattice)  ######load lattice ######
library(RColorBrewer) ######load colors#####


######Set working directory###########
setwd("D:/flight_data/ERA5/")
ncfname<- "albedo.nc" ######load data file#######
##################################################################

#####load nc file####
ncin<- nc_open(ncfname)
#####get longitude from file#####
lon <- ncvar_get(ncin, "longitude")
nlon<- dim(lon)
head(lon)
#####get latitude from file#####
lat<- ncvar_get(ncin, "latitude")
nlat<- dim(lat)
head(lat)
######Get time or dates########
tt<- ncvar_get(ncin, "time")
units<- ncatt_get(ncin, "time", "units")
ntt<-dim(tt)
head(tt)
print(c(nlon, nlat, ntt))

dname1 <- "fal"
fal.array1 <- ncvar_get(ncin, dname1)
dlname1<- ncatt_get(ncin, dname1, "long_name")
dunits1<- ncatt_get(ncin, dname1, "units")
fillvalue<- ncatt_get(ncin, dname1, "_FillValue")
dim(fal.array1)
##(ncdf4) automatically converts Fillvalues to NA######
######Convert t into vector format#######
fal.vec.long1<- as.vector(fal.array1)
length(fal.vec.long1)
###transform vector to matrix with latvs lon array as rows and each column as levels#####
#fal.mat <- matrix(fal.vec.long1, nrow=nlon*nlat, ncol=ntt)
#dim(fal.mat)
#head(na.omit(fal.mat))
tlonlat1<- as.matrix(expand.grid(lon, lat, tt))
fal_final <- data.frame(cbind(tlonlat1, fal.vec.long1))
fal_final$Var3<- as.POSIXct(fal_final$Var3*3600,origin='1900-01-01 00:00')
names(fal_final)<- c( "longitude", "latitude","date", "temperature")
df<- as.data.frame(fal_final)
write.table(df, "albedo.txt", sep = " ", row.names = FALSE)
