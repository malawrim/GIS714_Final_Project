# Data cleaning for zoning classes

# required make sure zone desc is in required format
# See description file https://docs.google.com/spreadsheets/d/1VTPvUM-_gQwGZUdfe8UDHM0Eoy0BVdV47sQxAIHgVJk/edit?usp=sharing

# if you don't have the libraries
# install.packages("data.table")
# install.packages("sp")
# install.packages("tmap")

library(data.table)
library(sp)
library(tmap)

# set working directory
wd <- "location_of_files"
setwd(wd)

# For parsing the description and filling in short_desc column from descriptor data
messy_data <- fread("filename.csv")

zone_classes <- list(list("Commercial",""),
                     list("Downtown","central business district", "CBD"),
                     list("Industrial"),
                     list("Office-Institutional"),
                     list("Open Space"),
                     list("Agriculture"),
                     list("Planned Development"),
                     list("Residential"),
                     list("Historic"),
                     list("Other"),
                     list("Mixed-Use"))

res_classes <- list(list("Residential High",4000, 6000),
                    list("Residential Medium-High", 7000, 12000),
                    list("Residential Medium",  15000, 20000),
                    list("Residential Low", 30000, 40000),
                    list("Residential Very-Low", 40001, Inf),
                    list("Residential Multifamily", "multi family", "multi-family"))

# function to find a matching string
grep_zone <- function(zone, zone_desc) {
  return(grepl(zone, zone_desc, ignore.case = T))
}

# column number where the zone description is
zone_descriptor <- 3

# for each row in the original data 
for (x in 1:nrow(messy_data)) {
  # search for every possible zone classes
  for (y in 1:length(zone_classes)) {
    # for each of our zone classes there are a number of possible words 
    # to look for in order to assign a class
    for (z in zone_classes[[y]]){
      # if there is a matching word assign the zone class
      # and increment the count column to keep record of any columns that are 
      # rewritten multiple times (try to assign multiple different classes to the same row)
      # this column will be used as a check to see if this works and potentially to assign
      # mixed-use zones
      if (grepl(z, messy_data[x, zone_descriptor]) == T) {
        # first handle residential
        if(is.equal(z, "Residential")){
          # if multifamily
            # assign multifamily
          # else
          # check description for any density units (acre, square footage)
          # do any unit conversions to get to square footage
          # check list for matches density to assign
          messy_data[x, c("ZnID")] <- res_classes[[index]]
        } else {
          messy_data[x, c("ZnID")] <- zone_classes[[y]][[1]]
        }
        messy_data[x, c("count")] <- messy_data[x, c("count")] + 1
        break
      }
    }
  }
}

## For merging spatial and non-spatial

# county description (.csv)
county_desc <- fread("filename.csv")

# county zones (shapefile)
original_zone <- readOGR(paste(wd, "/filename", sep = ""), "filename", verbose = FALSE)
# rename column with original zone ID to "org_zone"
# Replace 1 with the number of the column with the original zone ID
colnames(original_zone@data)[1] <- "org_zone"

# load Zone Classification formatting file
# here in Google Drive https://docs.google.com/spreadsheets/d/1j8v8FT9M6Oy5ZzLEZ0SGBBk_8dkzGb3QXRELnXmNSR4/edit?usp=sharing
zone_desc <- fread("Zone_classification.csv")

## If you have different tables for each municipality in a county ##
# merge each of the counties into one table first
# load all .csv from one folder
# filelist <- list.files(path = "folder path", pattern='.csv', all.files=TRUE, full.names=FALSE)
# zone_desc <- 
#   do.call(rbind,
#           lapply(filelist, fread))

county_desc_merge <- merge(county_desc, zone_desc, by.x="Zone", by.y="short_desc")

# join new zone class names to original
county_desc_merge <- merge(county_desc, zone_desc, by.x="Zone", by.y="short_desc")

# check that merge was successful
# check that the correct number of rows was produced
nrow(county_desc_merge) == nrow(county_desc)
# check correct number of columns
ncol(county_desc_merge) == 12
# check that no new NA's were introduced
sum(is.na(county_desc_merge)) == sum(is.na(county_desc))
# also do a couple of random checks in the actual data table to see if anything weird happened
View(county_desc_merge)

## If you have a shapefile with the descriptions in the attribute 
## table just load that data skip to this section

# merge the new datatable to the spatial data
# replace "zone" with column name of Zone ID in spatial file
couty_zone_merge <- merge(county_zone, county_desc_merge, by ="org_zone")
# check that merge was successful
# check that the correct number of rows was produced
nrow(couty_zone_merge) == nrow(county_zone)
# check correct number of columns
ncol(couty_zone_merge) == ncol(couty_zone) + ncol(county_desc_merge)
# check that no new NA's were introduced
sum(is.na(couty_zone_merge)) == sum(is.na(county_desc_merge)) + sum(is.na(county_zone))
# also do a couple of random checks in the actual data table to see if anything weird happened
View(couty_zone_merge)

# view map
tm_shape(couty_zone_merge) +
  tm_polygons("ZnCl")
