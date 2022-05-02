library(data.table)
library(rgdal)
library(raster)
library(sp)

## memory.limit(size=56000) ##

wd <- "C:/RA/Zoning/Raleigh_Prototype_Zoning"
setwd(wd)

# Housing Density
housing_size <- fread("Household_size/2019_household_bg.csv")
housing_size <- housing_size[-1,]
# remove country codes from GEOID
housing_size$GEO_ID <- gsub(".*US", "", housing_size$GEO_ID)
housing_size <- housing_size[,c("B25010_001E", "GEO_ID")]
setnames(housing_size, "B25010_001E", "housing_size")
housing_size$housing_size <- gsub("-", "0", housing_size$housing_size)
housing_size$GEO_ID <- as.numeric(housing_size$GEO_ID)
housing_size$housing_size <- as.numeric(housing_size$housing_size)

# Join to spatial block group file
bg <- readOGR("census_block_group", verbose = FALSE)
bg <- spTransform(bg, crs(harnett_zones$blg_area_rast))
bg$GEOID <- as.numeric(bg$GEOID)

housing_size_sp <- merge(bg, housing_size, by.x = c("GEOID"), by.y = c("GEO_ID"))

sum(is.na(housing_size_sp$housing_size))

writeOGR(housing_size_sp, dsn = "./housing_size_sp", layer = 'housing_size_sp', driver = "ESRI Shapefile")

# spatial join of person per household to zoning data
over(zones, housing_size_sp, )
extract(zones, housing_size_sp, )
over(wake_points, housing_size_sp)
crs(housing_size_sp)
crs(wake_points)

setwd("C:/RA/Zoning/Raleigh_Prototype_Zoning/Household_size/raw")
filelist <- list.files(path = "C:/RA/Zoning/Raleigh_Prototype_Zoning/Household_size/raw", pattern='*_household_bg.csv', all.files=TRUE, full.names=FALSE)
household_size <- lapply(filelist, fread)
setwd("C:/RA/Zoning/Raleigh_Prototype_Zoning/Household_size/")
setnames(household_size[[1]], "P017001", "B25010_001E")
setnames(household_size[[2]], "P017001", "B25010_001E")
for (i in 1:length(household_size)) {
  household_size[[i]] <- household_size[[i]][-1,]
  household_size[[i]]$GEO_ID <- gsub(".*US", "", household_size[[i]]$GEO_ID)
  household_size[[i]] <- household_size[[i]][,c("B25010_001E", "GEO_ID")]
  setnames(household_size[[i]], "B25010_001E", "hsng_sz")
  household_size[[i]]$GEO_ID <- as.numeric(household_size[[i]]$GEO_ID)
  household_size[[i]]$hsng_sz <- as.numeric(household_size[[i]]$hsng_sz)
  write.csv(household_size[[i]], filelist[i], row.names = FALSE)
}

setwd("C:/RA/Zoning/Raleigh_Prototype_Zoning/Household_size/raw")
filelist <- list.files(path = "C:/RA/Zoning/Raleigh_Prototype_Zoning/Household_size/raw", pattern='*_household_bg_sz.csv', all.files=TRUE, full.names=FALSE)
household_size_17_18 <- lapply(filelist, fread)
setwd("C:/RA/Zoning/Raleigh_Prototype_Zoning/Household_size/")
for (i in 1:length(household_size_17_18)) {
  household_size_17_18[[i]] <- household_size_17_18[[i]][-1,]
  household_size_17_18[[i]]$GEO_ID <- gsub(".*US", "", household_size_17_18[[i]]$GEO_ID)
  household_size_17_18[[i]]$hsng_sz <- (as.numeric(household_size_17_18[[i]]$B11016_010E) + 
    2 * (as.numeric(household_size_17_18[[i]]$B11016_003E) + as.numeric(household_size_17_18[[i]]$B11016_011E)) +
    3 * (as.numeric(household_size_17_18[[i]]$B11016_004E) + as.numeric(household_size_17_18[[i]]$B11016_012E)) + 
    4 * (as.numeric(household_size_17_18[[i]]$B11016_005E) + as.numeric(household_size_17_18[[i]]$B11016_013E)) + 
    5 * (as.numeric(household_size_17_18[[i]]$B11016_006E) + as.numeric(household_size_17_18[[i]]$B11016_014E)) + 
    6 * (as.numeric(household_size_17_18[[i]]$B11016_007E) + as.numeric(household_size_17_18[[i]]$B11016_015E)) + 
    7 * (as.numeric(household_size_17_18[[i]]$B11016_008E) + as.numeric(household_size_17_18[[i]]$B11016_016E))) / as.numeric(household_size_17_18[[i]]$B11016_001E)
  household_size_17_18[[i]] <- household_size_17_18[[i]][,c("hsng_sz", "GEO_ID")]
  household_size_17_18[[i]]$GEO_ID <- as.numeric(household_size_17_18[[i]]$GEO_ID)
  household_size_17_18[[i]]$hsng_sz <- as.numeric(household_size_17_18[[i]]$hsng_sz)
  write.csv(household_size_17_18[[i]], filelist[i], row.names = FALSE)
}

setwd("C:/RA/Zoning/Raleigh_Prototype_Zoning/Household_size/raw")
filelist <- list("2011_household_tract.csv", "2012_household_tract.csv")
household_size_11_12 <- lapply(filelist, fread)
setwd("C:/RA/Zoning/Raleigh_Prototype_Zoning/Household_size/")
for (i in 1:length(household_size_11_12)) {
  household_size_11_12[[i]] <- household_size_11_12[[i]][-1,]
  household_size_11_12[[i]]$GEO_ID <- gsub(".*US", "", household_size_11_12[[i]]$GEO_ID)
  household_size_11_12[[i]] <- household_size_11_12[[i]][,c("B25010_001E", "GEO_ID")]
  setnames(household_size_11_12[[i]], "B25010_001E", "hsng_sz")
  household_size_11_12[[i]]$GEO_ID <- as.numeric(household_size_11_12[[i]]$GEO_ID)
  household_size_11_12[[i]]$hsng_sz <- as.numeric(household_size_11_12[[i]]$hsng_sz)
  write.csv(household_size_11_12[[i]], filelist[[i]], row.names = FALSE)
}
