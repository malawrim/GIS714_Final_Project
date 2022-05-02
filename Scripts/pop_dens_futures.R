library(data.table)
library(matrixStats)
library(plotrix)
wd <- "D:\\futures\\FUTURESv2\\counts\\pd"
setwd(wd)

## Population Density ##

pd_groupings <- c(
  "stat_pd_dev_wake_2020*",
  "stat_pd_dev_wake_2035*",
  "stat_pd_dev_wake_2050*",
  "stat_pd_dev_randolph_2020*",
  "stat_pd_dev_randolph_2035*",
  "stat_pd_dev_randolph_2050*",
  "stat_pd_dev_harnett_2020*",
  "stat_pd_dev_harnett_2035*",
  "stat_pd_dev_harnett_2050*"
)

counts <- function(pattern) {
  count_files <- list.files(pattern=pattern)
  pop_dens_count <- lapply(count_files, fread, col.names = c("range", "count"))
  return(pop_dens_count)
}

# group_pop_dens_count <- lapply(pd_groupings, counts)

wake_pop_dens_count <- lapply(pd_groupings[1:3], counts)
randolph_pop_dens_count <- lapply(pd_groupings[4:6], counts)
harnett_pop_dens_count <- lapply(pd_groupings[7:9], counts)


# for (i in 1:length(wake_pop_dens_count)) {
#   for (j in 1:length(wake_pop_dens_count[[i]])) {
#     wake_pop_dens_count[[i]][[j]]$proportion <- wake_pop_dens_count[[i]][[j]]$count / sum(wake_pop_dens_count[[i]][[j]][1:13,2])
#   }
# }
# 
# wake_pd_comb_list <- list()
# for (j in 1:10) {
#   wake_pd_comb_count <- as.data.table(wake_pop_dens_count[[1]][[1]]$range)
#   colnames(wake_pd_comb_count) <- "range"
#   wake_pd_comb_count$count_2020 <- wake_pop_dens_count[[1]][[j]]$count
#   wake_pd_comb_count$proportion_2020 <- wake_pop_dens_count[[1]][[j]]$proportion
#   wake_pd_comb_count$count_2035 <- wake_pop_dens_count[[2]][[j]]$count
#   wake_pd_comb_count$proportion_2035 <- wake_pop_dens_count[[2]][[j]]$proportion
#   wake_pd_comb_count$count_2050 <- wake_pop_dens_count[[3]][[j]]$count
#   wake_pd_comb_count$proportion_2050 <- wake_pop_dens_count[[3]][[j]]$proportion
#   wake_pd_comb_count$dif_count_2020_2050 <- wake_pd_comb_count$count_2050 - wake_pd_comb_count$count_2020
#   wake_pd_comb_count$dif_proportion_2020_2050 <- wake_pd_comb_count$proportion_2050 - wake_pd_comb_count$proportion_2020
#   wake_pd_comb_list[[j]] <- wake_pd_comb_count
#   rm(wake_pd_comb_count)
# }

county_counts_proportion <- function (count_tab, comb_list) {
  for (i in 1:length(count_tab)) {
    for (j in 1:length(count_tab[[i]])) {
      count_tab[[i]][[j]]$proportion <- count_tab[[i]][[j]]$count / sum(count_tab[[i]][[j]][1:12,2])
    }
  }
  
  for (j in 1:10) {
    comb_count_tab <- as.data.table(count_tab[[1]][[1]]$range)
    colnames(comb_count_tab) <- "range"
    comb_count_tab$count_2020 <- count_tab[[1]][[j]]$count
    comb_count_tab$proportion_2020 <- count_tab[[1]][[j]]$proportion
    comb_count_tab$count_2035 <- count_tab[[2]][[j]]$count
    comb_count_tab$proportion_2035 <- count_tab[[2]][[j]]$proportion
    comb_count_tab$count_2050 <- count_tab[[3]][[j]]$count
    comb_count_tab$proportion_2050 <- count_tab[[3]][[j]]$proportion
    comb_count_tab$dif_count_2020_2050 <- comb_count_tab$count_2050 - comb_count_tab$count_2020
    comb_count_tab$dif_proportion_2020_2050 <- comb_count_tab$proportion_2050 - comb_count_tab$proportion_2020
    comb_list[[j]] <- comb_count_tab
    rm(comb_count_tab)
  }
  return(comb_list)
}

# each entry in list is stochastic result (1-10)
wake_pd_comb_list <- list()
wake_pd_comb_list <- county_counts_proportion(wake_pop_dens_count, wake_pd_comb_list)
harnett_pd_comb_list <- list()
harnett_pd_comb_list <- county_counts_proportion(harnett_pop_dens_count, harnett_pd_comb_list)
randolph_pd_comb_list <- list()
randolph_pd_comb_list <- county_counts_proportion(randolph_pop_dens_count, randolph_pd_comb_list)

wake_pd_org <- fread("stat_pd_dev_wake_org.csv", col.names = c("pd", "count"))
harnett_pd_org <- fread("stat_pd_dev_harnett_org.csv", col.names = c("pd", "count"))
randolph_pd_org <- fread("stat_pd_dev_randolph_org.csv", col.names = c("pd", "count"))

## Zones ##
wd <- "D:\\futures\\FUTURESv2\\counts\\zone"
setwd(wd)

zone_groupings <- c(
  "stat_zone_dev_wake_2020*",
  "stat_zone_dev_wake_2035*",
  "stat_zone_dev_wake_2050*",
  "stat_zone_dev_randolph_2020*",
  "stat_zone_dev_randolph_2035*",
  "stat_zone_dev_randolph_2050*",
  "stat_zone_dev_harnett_2020*",
  "stat_zone_dev_harnett_2035*",
  "stat_zone_dev_harnett_2050*"
)

counts <- function(pattern) {
  count_files <- list.files(pattern=pattern)
  pop_dens_count <- lapply(count_files, fread, col.names = c("zone", "count"))
  return(pop_dens_count)
}

# group_pop_dens_count <- lapply(zone_groupings, counts)

wake_zone_count <- lapply(zone_groupings[1:3], counts)
randolph_zone_count <- lapply(zone_groupings[4:6], counts)
harnett_zone_count <- lapply(zone_groupings[7:9], counts)

zone_county_counts_proportion <- function (count_tab, comb_list) {
  for (i in 1:length(count_tab)) {
    for (j in 1:length(count_tab[[i]])) {
      count_tab[[i]][[j]] <- count_tab[[i]][[j]][zone != 6 & zone != 7 & zone != 9 & zone != 10,]
      count_tab[[i]][[j]]$proportion <- count_tab[[i]][[j]]$count / sum(count_tab[[i]][[j]][1:9,2])
    }
  }
  
  for (j in 1:10) {
    comb_count_tab <- as.data.table(count_tab[[1]][[1]]$zone)
    colnames(comb_count_tab) <- "zone"
    comb_count_tab$count_2020 <- count_tab[[1]][[j]]$count
    comb_count_tab$proportion_2020 <- count_tab[[1]][[j]]$proportion
    comb_count_tab$count_2035 <- count_tab[[2]][[j]]$count
    comb_count_tab$proportion_2035 <- count_tab[[2]][[j]]$proportion
    comb_count_tab$count_2050 <- count_tab[[3]][[j]]$count
    comb_count_tab$proportion_2050 <- count_tab[[3]][[j]]$proportion
    comb_count_tab$dif_count_2020_2050 <- comb_count_tab$count_2050 - comb_count_tab$count_2020
    comb_count_tab$dif_proportion_2020_2050 <- comb_count_tab$proportion_2050 - comb_count_tab$proportion_2020
    comb_list[[j]] <- comb_count_tab
    rm(comb_count_tab)
  }
  return(comb_list)
}

zone_names <- c("Commercial", "Mixed-use", "Industrial", "Office and Institutional", "Open Space", "Residential-High Density", "Residential-Medium Density", "Residential-Low Density", "Residential-Very Low Density")

# each entry in list is stochastic result (1-10)
wake_zone_comb_list <- list()
wake_zone_comb_list <- zone_county_counts_proportion(wake_zone_count, wake_zone_comb_list)
harnett_zone_comb_list <- list()
harnett_zone_comb_list <- zone_county_counts_proportion(harnett_zone_count, harnett_zone_comb_list)
randolph_zone_comb_list <- list()
randolph_zone_comb_list <- zone_county_counts_proportion(randolph_zone_count, randolph_zone_comb_list)

wake_zone_org <- fread("stat_zone_dev_wake_org.csv", col.names = c("zone", "count"))[c(1:5, 8, 10,11,12),]
harnett_zone_org <- fread("stat_zone_dev_harnett_org.csv", col.names = c("zone", "count"))[c(1:6, 8:10),]
randolph_zone_org <- fread("stat_zone_dev_randolph_org.csv", col.names = c("zone", "count"))[c(1:5, 7, 10:12),]
for (i in 1:nrow(wake_zone_org)) {
  wake_zone_org[i,]$proportion <- wake_zone_org[i,2]/sum(wake_zone_org$count)
  harnett_zone_org[i,]$proportion <- harnett_zone_org[i,2]/sum(harnett_zone_org$count)
  randolph_zone_org[i,]$proportion <- randolph_zone_org[i,2]/sum(randolph_zone_org$count)
}
wake_zone_org$zone_name <- zone_names
harnett_zone_org$zone_name <- zone_names
randolph_zone_org$zone_name <- zone_names

all_zone_org <- data.table(wake_zone_org$zone, wake_zone_org$zone_name)
all_zone_org$count <- rowsum(as.matrix(cbind(wake_zone_org$count, harnett_zone_org$count, randolph_zone_org$count)), group = c(1:9))
all_count <- as.data.table(cbind(wake_zone_org$count, harnett_zone_org$count, randolph_zone_org$count))
all_count[, Sum := rowSums(.SD), .SDcols = 1:3]
for (i in 1:nrow(all_count)) {
  all_count[i,]$proportion <- all_count[i,4]/sum(all_count$Sum)
}
all_count$zone_name <- zone_names

wd <- "D:\\futures\\FUTURESv2\\counts\\zone"
setwd(wd)
# add all stochastic results from one year to a single table


# randolph_stoch_count_2020 <- data.table( 
#                                 s1 = randolph_zone_comb_list[[1]][,2],
#                                 s2 = randolph_zone_comb_list[[2]][,2],
#                                 s3 = randolph_zone_comb_list[[3]][,2],
#                                 s4 = randolph_zone_comb_list[[4]][,2],
#                                 s5 = randolph_zone_comb_list[[5]][,2],
#                                 s6 = randolph_zone_comb_list[[6]][,2],
#                                 s7 = randolph_zone_comb_list[[7]][,2],
#                                 s8 = randolph_zone_comb_list[[8]][,2],
#                                 s9 = randolph_zone_comb_list[[9]][,2])
# randolph_stoch_count_2020 <- randolph_stoch_count_2020[1:9,]
# randolph_stoch_count_2020[, varience:= rowVars(as.matrix(.SD))]
# randolph_stoch_count_2020$sd <- apply(randolph_stoch_count_2020[,1:9], 1, sd)  
# # randolph_stoch_count_2020[, max:= do.call(pmax, .SD)]
# # randolph_stoch_count_2020[, min:= do.call(pmin, .SD)]
# randolph_stoch_count_2020$mean <- rowMeans(randolph_stoch_count_2020[,1:9])
# 
# randolph_stoch_count_2020 <- cbind(randolph_zone_comb_list[[9]][1:9,1], randolph_stoch_count_2020)
# randolph_stoch_count_2020$zone_name <- zone_names
# 
# randolph_stoch_count_2035 <- data.table( 
#   s1 = randolph_zone_comb_list[[1]][,4],
#   s2 = randolph_zone_comb_list[[2]][,4],
#   s3 = randolph_zone_comb_list[[3]][,4],
#   s4 = randolph_zone_comb_list[[4]][,4],
#   s5 = randolph_zone_comb_list[[5]][,4],
#   s6 = randolph_zone_comb_list[[6]][,4],
#   s7 = randolph_zone_comb_list[[7]][,4],
#   s8 = randolph_zone_comb_list[[8]][,4],
#   s9 = randolph_zone_comb_list[[9]][,4])
# randolph_stoch_count_2035 <- randolph_stoch_count_2035[1:9,]
# randolph_stoch_count_2035[, varience:= rowVars(as.matrix(.SD))]
# randolph_stoch_count_2035$sd <- apply(randolph_stoch_count_2035[,1:9], 1, sd)  
# # randolph_stoch_count_2035[, max:= do.call(pmax, .SD)]
# # randolph_stoch_count_2035[, min:= do.call(pmin, .SD)]
# randolph_stoch_count_2035$mean <- rowMeans(randolph_stoch_count_2035[,1:9])
# 
# randolph_stoch_count_2035 <- cbind(randolph_zone_comb_list[[9]][1:9,1], randolph_stoch_count_2035)
# randolph_stoch_count_2035$zone_name <- zone_names
# 
# randolph_stoch_count_2050 <- data.table( 
#   s1 = randolph_zone_comb_list[[1]][,6],
#   s2 = randolph_zone_comb_list[[2]][,6],
#   s3 = randolph_zone_comb_list[[3]][,6],
#   s4 = randolph_zone_comb_list[[4]][,6],
#   s5 = randolph_zone_comb_list[[5]][,6],
#   s6 = randolph_zone_comb_list[[6]][,6],
#   s7 = randolph_zone_comb_list[[7]][,6],
#   s8 = randolph_zone_comb_list[[8]][,6],
#   s9 = randolph_zone_comb_list[[9]][,6])
# randolph_stoch_count_2050 <- randolph_stoch_count_2050[1:9,]
# randolph_stoch_count_2050[, varience:= rowVars(as.matrix(.SD))]
# randolph_stoch_count_2050$sd <- apply(randolph_stoch_count_2050[,1:9], 1, sd)  
# # randolph_stoch_count_2050[, max:= do.call(pmax, .SD)]
# # randolph_stoch_count_2050[, min:= do.call(pmin, .SD)]
# randolph_stoch_count_2050$mean <- rowMeans(randolph_stoch_count_2050[,1:9])
# 
# randolph_stoch_count_2050 <- cbind(randolph_zone_comb_list[[9]][1:9,1], randolph_stoch_count_2050)
# randolph_stoch_count_2050$zone_name <- zone_names
# 
# randolph_full_time <- data.table(randolph_stoch_count_2035$zone,
#                                  randolph_stoch_count_2035$zone_name,
#                                  mean_2020 = randolph_stoch_count_2020$mean,
#                                  sd_2020 = randolph_stoch_count_2020$sd,
#                                  mean_2035 = randolph_stoch_count_2035$mean,
#                                  sd_2035 = randolph_stoch_count_2035$sd,
#                                  mean_2050 = randolph_stoch_count_2050$mean,
#                                  sd_2050 = randolph_stoch_count_2050$sd)

stats <- function(county_comb_list) {
  count_2020 <- data.table( 
    s1 = county_comb_list[[1]][,2],
    s2 = county_comb_list[[2]][,2],
    s3 = county_comb_list[[3]][,2],
    s4 = county_comb_list[[4]][,2],
    s5 = county_comb_list[[5]][,2],
    s6 = county_comb_list[[6]][,2],
    s7 = county_comb_list[[7]][,2],
    s8 = county_comb_list[[8]][,2],
    s9 = county_comb_list[[9]][,2],
    s10 = county_comb_list[[10]][,2])
  ## change to 1:9 for zones ##
  count_2020 <- count_2020[1:12,]
  count_2020[, varience:= rowVars(as.matrix(.SD))]
  count_2020$sd <- apply(count_2020[,1:9], 1, sd)  
  # count_2020[, max:= do.call(pmax, .SD)]
  # count_2020[, min:= do.call(pmin, .SD)]
  count_2020$mean <- rowMeans(count_2020[,1:9])
  ## change to 1:9 for zones ##
  count_2020 <- cbind(county_comb_list[[9]][1:12,1], count_2020)
  # count_2020$zone_name <- zone_names
  count_2035 <- data.table( 
    s1 = county_comb_list[[1]][,4],
    s2 = county_comb_list[[2]][,4],
    s3 = county_comb_list[[3]][,4],
    s4 = county_comb_list[[4]][,4],
    s5 = county_comb_list[[5]][,4],
    s6 = county_comb_list[[6]][,4],
    s7 = county_comb_list[[7]][,4],
    s8 = county_comb_list[[8]][,4],
    s9 = county_comb_list[[9]][,4],
    s10 = county_comb_list[[10]][,4])
  count_2035 <- count_2035[1:12,]
  count_2035[, varience:= rowVars(as.matrix(.SD))]
  count_2035$sd <- apply(count_2035[,1:9], 1, sd)  
  # count_2035[, max:= do.call(pmax, .SD)]
  # count_2035[, min:= do.call(pmin, .SD)]
  count_2035$mean <- rowMeans(count_2035[,1:9])
  
  count_2035 <- cbind(county_comb_list[[9]][1:12,1], count_2035)
  # count_2035$zone_name <- zone_names
  
  count_2050 <- data.table( 
    s1 = county_comb_list[[1]][,6],
    s2 = county_comb_list[[2]][,6],
    s3 = county_comb_list[[3]][,6],
    s4 = county_comb_list[[4]][,6],
    s5 = county_comb_list[[5]][,6],
    s6 = county_comb_list[[6]][,6],
    s7 = county_comb_list[[7]][,6],
    s8 = county_comb_list[[8]][,6],
    s9 = county_comb_list[[9]][,6],
    s10 = county_comb_list[[10]][,6])
  count_2050 <- count_2050[1:12,]
  count_2050[, varience:= rowVars(as.matrix(.SD))]
  count_2050$sd <- apply(count_2050[,1:9], 1, sd)  
  # count_2050[, max:= do.call(pmax, .SD)]
  # count_2050[, min:= do.call(pmin, .SD)]
  count_2050$mean <- rowMeans(count_2050[,1:9])
  
  count_2050 <- cbind(county_comb_list[[9]][1:12,1], count_2050)
  # count_2050$zone_name <- zone_names
  
  return(data.table(count_2020$range,
                     # count_2035$zone_name,
                     mean_2020 = count_2020$mean,
                     sd_2020 = count_2020$sd,
                     mean_2035 = count_2035$mean,
                     sd_2035 = count_2035$sd,
                     mean_2050 = count_2050$mean,
                     sd_2050 = count_2050$sd))
}

randolph_full_time <- stats(randolph_zone_comb_list)
harnett_full_time <- stats(harnett_zone_comb_list)
wake_full_time <- stats(wake_zone_comb_list)

randolph_full_time_pd <- stats(randolph_pd_comb_list)
harnett_full_time_pd <- stats(harnett_pd_comb_list)
wake_full_time_pd <- stats(wake_pd_comb_list)

all_full_time <- data.table(randolph_full_time$V1, randolph_full_time$V2)
all_2020 <- as.data.table(cbind(randolph_full_time$mean_2020, wake_full_time$mean_2020, harnett_full_time$mean_2020))
all_2020[, Sum := rowSums(.SD), .SDcols = 1:3]
all_2020$proportion <- 0
for (i in 1:nrow(all_2020)) {
  all_2020[i,]$proportion <- all_2020[i,4]/sum(all_2020$Sum)
}
all_2035 <- as.data.table(cbind(randolph_full_time$mean_2035, wake_full_time$mean_2035, harnett_full_time$mean_2035))
all_2035[, Sum := rowSums(.SD), .SDcols = 1:3]
all_2035$proportion <- 0
for (i in 1:nrow(all_2035)) {
  all_2035[i,]$proportion <- all_2035[i,4]/sum(all_2035$Sum)
}
all_2050 <- as.data.table(cbind(randolph_full_time$mean_2050, wake_full_time$mean_2050, harnett_full_time$mean_2050))
all_2050[, Sum := rowSums(.SD), .SDcols = 1:3]
all_2050$proportion <- 0
for (i in 1:nrow(all_2050)) {
  all_2050[i,]$proportion <- all_2050[i,4]/sum(all_2050$Sum)
}

# Find the all_county mean
all_full_time <- data.table(randolph_full_time$V1, randolph_full_time$V2)
all_full_time$mean_2020 <- all_2020$Sum
all_full_time$mean_2035 <- all_2035$Sum
all_full_time$mean_2050 <-all_2050$Sum

all_full_time_pd <- data.table(randolph_full_time_pd$V1, randolph_full_time_pd$V2)
all_2020_pd <- as.data.table(cbind(randolph_full_time_pd$mean_2020, wake_full_time_pd$mean_2020, harnett_full_time_pd$mean_2020))
all_2020_pd[, Sum := rowSums(.SD), .SDcols = 1:3]
all_2020_pd$proportion <- 0
for (i in 1:nrow(all_2020_pd)) {
  all_2020_pd[i,]$proportion <- all_2020_pd[i,4]/sum(all_2020_pd$Sum)
}
all_2035_pd <- as.data.table(cbind(randolph_full_time_pd$mean_2035, wake_full_time_pd$mean_2035, harnett_full_time_pd$mean_2035))
all_2035_pd[, Sum := rowSums(.SD), .SDcols = 1:3]
all_2035_pd$proportion <- 0
for (i in 1:nrow(all_2035_pd)) {
  all_2035_pd[i,]$proportion <- all_2035_pd[i,4]/sum(all_2035_pd$Sum)
}
all_2050_pd <- as.data.table(cbind(randolph_full_time_pd$mean_2050, wake_full_time_pd$mean_2050, harnett_full_time_pd$mean_2050))
all_2050_pd[, Sum := rowSums(.SD), .SDcols = 1:3]
all_2050_pd$proportion <- 0
for (i in 1:nrow(all_2050_pd)) {
  all_2050_pd[i,]$proportion <- all_2050_pd[i,4]/sum(all_2050_pd$Sum)
}

# Find the all_county mean pop dens
all_full_time_pd <- data.table(randolph_full_time_pd$V1, randolph_full_time_pd$V2)
all_full_time_pd$mean_2020 <- all_2020_pd$Sum
all_full_time_pd$mean_2035 <- all_2035_pd$Sum
all_full_time_pd$mean_2050 <- all_2050_pd$Sum


## Proportion
proportion <- function(county_comb_list) {
  ## change to 9 for zones and 12 for pd##
  max_row <- 12
  count_2020 <- data.table( 
    s1 = county_comb_list[[1]][,3],
    s2 = county_comb_list[[2]][,3],
    s3 = county_comb_list[[3]][,3],
    s4 = county_comb_list[[4]][,3],
    s5 = county_comb_list[[5]][,3],
    s6 = county_comb_list[[6]][,3],
    s7 = county_comb_list[[7]][,3],
    s8 = county_comb_list[[8]][,3],
    s9 = county_comb_list[[9]][,3],
    s10 = county_comb_list[[10]][,3])
  
  count_2020 <- count_2020[1:max_row,]
  count_2020[, varience:= rowVars(as.matrix(.SD))]
  count_2020$sd <- apply(count_2020[,1:10], 1, sd)  
  # count_2020[, max:= do.call(pmax, .SD)]
  # count_2020[, min:= do.call(pmin, .SD)]
  count_2020$mean <- rowMeans(count_2020[,1:10])
  count_2020 <- cbind(county_comb_list[[9]][1:max_row,1], count_2020)
  # count_2020$zone_name <- zone_names
  count_2035 <- data.table( 
    s1 = county_comb_list[[1]][,5],
    s2 = county_comb_list[[2]][,5],
    s3 = county_comb_list[[3]][,5],
    s4 = county_comb_list[[4]][,5],
    s5 = county_comb_list[[5]][,5],
    s6 = county_comb_list[[6]][,5],
    s7 = county_comb_list[[7]][,5],
    s8 = county_comb_list[[8]][,5],
    s9 = county_comb_list[[9]][,5],
    s10 = county_comb_list[[10]][,5])
  count_2035 <- count_2035[1:max_row,]
  count_2035[, varience:= rowVars(as.matrix(.SD))]
  count_2035$sd <- apply(count_2035[,1:10], 1, sd)  
  # count_2035[, max:= do.call(pmax, .SD)]
  # count_2035[, min:= do.call(pmin, .SD)]
  count_2035$mean <- rowMeans(count_2035[,1:10])
  
  count_2035 <- cbind(county_comb_list[[9]][1:max_row,1], count_2035)
  # count_2035$zone_name <- zone_names
  
  count_2050 <- data.table( 
    s1 = county_comb_list[[1]][,7],
    s2 = county_comb_list[[2]][,7],
    s3 = county_comb_list[[3]][,7],
    s4 = county_comb_list[[4]][,7],
    s5 = county_comb_list[[5]][,7],
    s6 = county_comb_list[[6]][,7],
    s7 = county_comb_list[[7]][,7],
    s8 = county_comb_list[[8]][,7],
    s9 = county_comb_list[[9]][,7],
    s10 = county_comb_list[[10]][,7])
  count_2050 <- count_2050[1:max_row,]
  count_2050[, varience:= rowVars(as.matrix(.SD))]
  count_2050$sd <- apply(count_2050[,1:10], 1, sd)  
  # count_2050[, max:= do.call(pmax, .SD)]
  # count_2050[, min:= do.call(pmin, .SD)]
  count_2050$mean <- rowMeans(count_2050[,1:10])
  
  count_2050 <- cbind(county_comb_list[[9]][1:max_row,1], count_2050)
  # count_2050$zone_name <- zone_names
  
  # #zone
  # return(data.table(count_2020$zone,
  #                   count_2050$zone_name,
  #                   mean_2020 = count_2020$mean,
  #                   sd_2020 = count_2020$sd,
  #                   mean_2035 = count_2035$mean,
  #                   sd_2035 = count_2035$sd,
  #                   mean_2050 = count_2050$mean,
  #                   sd_2050 = count_2050$sd))
  # 
  # pop dens
  return(data.table(count_2020$range,
                    mean_2020 = count_2020$mean,
                    sd_2020 = count_2020$sd,
                    mean_2035 = count_2035$mean,
                    sd_2035 = count_2035$sd,
                    mean_2050 = count_2050$mean,
                    sd_2050 = count_2050$sd))
}

randolph_proportion_full_time <- proportion(randolph_zone_comb_list)
harnett_proportion_full_time <- proportion(harnett_zone_comb_list)
wake_proportion_full_time <- proportion(wake_zone_comb_list)

randolph_proportion_full_time_pd <- proportion(randolph_pd_comb_list)
harnett_proportion_full_time_pd <- proportion(harnett_pd_comb_list)
wake_proportion_full_time_pd <- proportion(wake_pd_comb_list)

# Find the all_county mean
all_full_time_proportion <- data.table(randolph_full_time$V1, randolph_full_time$V2)
all_full_time_proportion$mean_2020 <- all_2020$proportion
all_full_time_proportion$mean_2035 <- all_2035$proportion
all_full_time_proportion$mean_2050 <-all_2050$proportion

# Find the all_county mean pop dens
all_full_time_pd_proportion <- data.table(randolph_full_time_pd$V1)
all_full_time_pd_proportion$mean_2020 <- all_full_time_pd$proportion
all_full_time_pd_proportion$mean_2035 <- all_full_time_pd$proportion
all_full_time_pd_proportion$mean_2050 <-all_full_time_pd$proportion

all_full_time_pd_proportion <- data.table(randolph_proportion_full_time_pd$V1, randolph_proportion_full_time_pd$V2)
all_full_time_pd_proportion$mean_2020 <- rowMeans(cbind(randolph_proportion_full_time_pd$mean_2020, wake_proportion_full_time_pd$mean_2020, harnett_proportion_full_time_pd$mean_2020))
all_full_time_pd_proportion$mean_2035 <- rowMeans(cbind(randolph_proportion_full_time_pd$mean_2035, wake_proportion_full_time_pd$mean_2035, harnett_proportion_full_time_pd$mean_2035))
all_full_time_pd_proportion$mean_2050 <- rowMeans(cbind(randolph_proportion_full_time_pd$mean_2050, wake_proportion_full_time_pd$mean_2050, harnett_proportion_full_time_pd$mean_2050))


#plot
#reorder in descending order
# randolph_stoch_count_2020 <- randolph_stoch_count_2020[order(mean),]

# Horizontal bar plot
#par(mar=c(2, 12, 2, 2) + 0.1, bg = "#f7f7f7")
#barplot(t(randolph_stoch_count_2020[1:9]$mean), names.arg = randolph_stoch_count_2020[1:9]$zone_name, cex.names=0.8, beside=T, las = 1, horiz = T, main = "Randolph Mean Zone Distribution 2020")

# scatter plot with error bars
# range(c(randolph_stoch_count_2020$mean-randolph_stoch_count_2020$sd, randolph_stoch_count_2020$mean+randolph_stoch_count_2020$sd))
plot.new()
par(mar=c(15, 5, 2, 2) + 0.1, bg = "#f7f7f7")
plot(randolph_stoch_count_2020$mean,
     ylim= c(630, 20900),
     pch=19,  ylab="mean", xlab = "",
     main="Scatter plot with std.dev error bars", xaxt = "n"
)
axis(1, at = 1:9, labels = randolph_stoch_count_2020$zone_name, las = 2)
# randolph_stoch_count_2020$x <- 1:9
# plus <- c(9866.2818,  3399.0009,18328.2883,680.9698,1506.4364,4669.0481,14891.2053,134387.9337,19420.4421)
# minus <- c(9798.3848,3359.4436,18057.9340,630.3635,1496.8970,4564.9519,14552.3502,133690.7329,18953.7801)
arrows(x0 = 1:9, y0= randolph_stoch_count_2020$mean-randolph_stoch_count_2020$sd, x1=1:9, y1=randolph_stoch_count_2020$mean+randolph_stoch_count_2020$sd, length=0.05, angle=90, code=3)

# Plot three times on one plot pd with total gap
min_gap <- 160000
max_gap <- 430000
gap.plot(x = years, y = all_full_time_pd[1,2:4], gap=c(min_gap, max_gap),
         ylim = (range(c(min(all_full_time_pd[,2:4]), sum(all_full_time_pd$mean_2050)))),
         pch=19,  ylab="average number of developed cells (in thousands)", xlab = "years", col = "#c9aadc",
         xtics = F, ytics =F,  type = "b")
axis.break(2, min_gap*(1+0.02), breakcol="black", style="slash")
axis.break(4, min_gap*(1+0.02), breakcol="black", style="slash")
par(mar=c(15, 5, 2, 15) + 0.1, bg = "#ffffff", xpd=T)
legend("right", inset=c(-0.4,0), legend = c(all_full_time_pd$V1,"total"), pch = 19, col = c("#c9aadc", "#b294c6", "#9b7faf", "#846b99", "#715683", "#715683", "#5b436f", "#5b436f", "#47315b", "#47315b", "#322048", "#322048", "black"))
gap.plot(x = years, y = all_full_time_pd[2,2:4], pch=19, col = "#b294c6", type = "b", gap=c(min_gap, max_gap), add = T )
gap.plot(x = years, y = all_full_time_pd[3,2:4], pch=19, col = "#9b7faf", type = "b", gap=c(min_gap, max_gap), add = T )
gap.plot(x = years, y = all_full_time_pd[4,2:4], pch=19, col = "#846b99", type = "b", gap=c(min_gap, max_gap), add = T )
gap.plot(x = years, y = all_full_time_pd[5,2:4], pch=19, col = "#715683", type = "b", gap=c(min_gap, max_gap), add = T )
gap.plot(x = years, y = all_full_time_pd[6,2:4], pch=19, col = "#715683", type = "b", gap=c(min_gap, max_gap), add = T )
gap.plot(x = years, y = all_full_time_pd[7,2:4], pch=19, col = "#5b436f", type = "b", gap=c(min_gap, max_gap), add = T )
gap.plot(x = years, y = all_full_time_pd[8,2:4], pch=19, col = "#5b436f", type = "b", gap=c(min_gap, max_gap), add = T )
gap.plot(x = years, y = all_full_time_pd[9,2:4], pch=19, col = "#47315b", type = "b", gap=c(min_gap, max_gap), add = T )
gap.plot(x = years, y = all_full_time_pd[10,2:4], pch=19, col = "#47315b", type = "b", gap=c(min_gap, max_gap), add = T )
gap.plot(x = years, y = all_full_time_pd[11,2:4], pch=19, col = "#322048", type = "b", gap=c(min_gap, max_gap), add = T )
gap.plot(x = years, y = all_full_time_pd[12,2:4], pch=19, col = "black", type = "b", gap=c(min_gap, max_gap), add = T )
gap.plot(x = years, y = c(sum(all_full_time_pd$mean_2020), sum(all_full_time_pd$mean_2035), sum(all_full_time_pd$mean_2050)), pch=19, col = "#322048", type = "b", gap=c(min_gap, max_gap), add = T )
axis(1, at = years, labels = years)
lab <- c(seq.int(0, 160, by=10), seq.int(430, 490, by=10))
axis(2, at =c(seq.int(0, 230000, by=10000)), labels = lab)


# Plot three times on one plot pd
par(mar=c(15, 5, 2, 8) + 0.1, bg = "#ffffff")
# years <- c(2020, 2035, 2050)
plot(x = years, y = all_full_time_pd[1,2:4],
     ylim = (range(c(min(all_full_time_pd[,2:4]), sum(all_full_time_pd$mean_2050)))),
     pch=19,  ylab="average number of developed cells (in thousands)", xlab = "years", col = "#c9aadc",
     xaxt = "n", yaxt = "n",  type = "b"
)
points(x = years, y = all_full_time_pd[2,2:4], pch=19, col = "#b294c6", type = "b")
points(x = years, y = all_full_time_pd[3,2:4], pch=19, col = "#9b7faf", type = "b")
points(x = years, y = all_full_time_pd[4,2:4], pch=19, col = "#846b99", type = "b")
points(x = years, y = all_full_time_pd[5,2:4], pch=19, col = "#715683", type = "b")
points(x = years, y = all_full_time_pd[6,2:4], pch=19, col = "#715683", type = "b")
points(x = years, y = all_full_time_pd[7,2:4], pch=19, col = "#5b436f", type = "b")
points(x = years, y = all_full_time_pd[8,2:4], pch=19, col = "#5b436f", type = "b")
points(x = years, y = all_full_time_pd[9,2:4], pch=19, col = "#47315b", type = "b")
points(x = years, y = all_full_time_pd[10,2:4], pch=19, col = "#47315b", type = "b")
points(x = years, y = all_full_time_pd[11,2:4], pch=19, col = "#322048", type = "b")
points(x = years, y = all_full_time_pd[12,2:4], pch=19, col = "black", type = "b")
points(x = years, y = c(sum(all_full_time_pd$mean_2020), sum(all_full_time_pd$mean_2035), sum(all_full_time_pd$mean_2050)), pch=19, col = "#322048", type = "b")

axis(1, at = years, labels = years)
axis(2, at =seq.int(0, 500000, by=10000), labels = seq.int(0, 500, by=10))
legend("topright", inset=c(-0.3,0), legend = all_full_time_pd$V1, pch = 19, col = c("#c9aadc", "#b294c6", "#9b7faf", "#846b99", "#715683", "#715683", "#5b436f", "#5b436f", "#47315b", "#47315b", "#322048", "#322048"))

# Plot three times on one plot - zones with gap and total
min_gap <- 100000
max_gap <- 310000
gap.plot(x = years, y = all_full_time[1,3:5],
         ylim = (range(c(min(all_full_time[,3:5]), sum(all_full_time$mean_2050)))),
         pch=19,  ylab="average number of developed cells (in thousands)", xlab = "years", col = "#ff8989",
         xtics = F, ytics =F,  gap=c(min_gap, max_gap), type = "b")
axis.break(2, min_gap*(1+0.02), breakcol="black", style="slash")
axis.break(4, min_gap*(1+0.02), breakcol="black", style="slash")
par(mar=c(15, 5, 2, 15) + 0.1, bg = "#ffffff", xpd=T)
legend("right", inset=c(-1.2,0), legend = c(all_full_time[c(1:3,5:9),]$V2, "total"), pch = 19, col = c("#ff8989", "#355070", "#b56576", "#eaac8b", "#392942", "#8b7696", "#a997b2", "#c8bace", "black"))
gap.plot(x = years, y = all_full_time[2,3:5], pch=19, col = "#355070", type = "b", gap=c(min_gap, max_gap), add = T )
gap.plot(x = years, y = all_full_time[3,3:5], pch=19, col = "#b56576", type = "b", gap=c(min_gap, max_gap), add = T )
gap.plot(x = years, y = all_full_time[5,3:5], pch=19, col = "#eaac8b", type = "b", gap=c(min_gap, max_gap), add = T )
gap.plot(x = years, y = all_full_time[6,3:5], pch=19, col = "#392942", type = "b", gap=c(min_gap, max_gap), add = T )
gap.plot(x = years, y = all_full_time[7,3:5], pch=19, col = "#8b7696", type = "b", gap=c(min_gap, max_gap), add = T )
gap.plot(x = years, y = all_full_time[8,3:5], pch=19, col = "#a997b2", type = "b", gap=c(min_gap, max_gap), add = T )
gap.plot(x = years, y = all_full_time[9,3:5], pch=19, col = "#c8bace", type = "b", gap=c(min_gap, max_gap), add = T )
gap.plot(x = years, y = c(sum(all_full_time$mean_2020), sum(all_full_time$mean_2035), sum(all_full_time$mean_2050)), pch=19, col = "black", type = "b", gap=c(min_gap, max_gap), add = T )
axis(1, at = years, labels = years)
lab <- c(seq.int(0, 100, by=10), seq.int(310, 350, by=10))
axis(2, at =c(seq.int(0, 150000, by=10000)), labels = lab)

# Plot three times on one plot - zones
par(mar=c(15, 5, 2, 15) + 0.1, bg = "#ffffff", xpd=T)
# years <- c(2020, 2035, 2050)
plot(x = years, y = all_full_time[1,3:5],
     ylim = (range(c(min(all_full_time[,3:5]), max(all_full_time[,3:5])))),
     pch=19,  ylab="average number of developed cells (in thousands)", xlab = "years", col = "#ff8989",
      xaxt = "n", yaxt = "n", type = "b"
)
points(x = years, y = all_full_time[2,3:5], pch=19, col = "#355070", type = "b")
points(x = years, y = all_full_time[3,3:5], pch=19, col = "#b56576", type = "b")
points(x = years, y = all_full_time[5,3:5], pch=19, col = "#eaac8b", type = "b")
points(x = years, y = all_full_time[6,3:5], pch=19, col = "#392942", type = "b")
points(x = years, y = all_full_time[7,3:5], pch=19, col = "#8b7696", type = "b")
points(x = years, y = all_full_time[8,3:5], pch=19, col = "#a997b2", type = "b")
points(x = years, y = all_full_time[9,3:5], pch=19, col = "#c8bace", type = "b")
axis(1, at = years, labels = years)
axis(2, at =seq.int(0, 100000, by=10000), labels = c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100))
legend("topright", inset=c(-1.2,0), legend = all_full_time[c(1:3,5:9),]$V2, pch = 19, col = c("#ff8989", "#355070", "#b56576", "#eaac8b", "#392942", "#8b7696", "#a997b2", "#c8bace"))
seq.int(0, 100000, by=10000)

# Total development plotted alone
par(mar=c(15, 5, 2, 15) + 0.1, bg = "#ffffff", xpd=T)
# years <- c(2020, 2035, 2050)
plot(x = years, y = c(sum(all_full_time$mean_2020), sum(all_full_time$mean_2035), sum(all_full_time$mean_2050)),
     ylim = (range(310000, sum(all_full_time$mean_2050))),
     pch=19,  ylab="average number of developed cells 
     (in thousands)", xlab = "years", col = "black",
     xaxt = "n", yaxt = "n", type = "b"
)
axis(1, at = years, labels = years)
axis(2, at =seq.int(310000, 350000, by=10000), labels = c(310, 320, 330, 340, 350))

all_full_time[9,3:5]
lm(counts~years)$coeff[[2]]

slope <- function(counts, years) {
  return(lm(counts~years)$coeff[[2]])
}
slope(slope_format, years)

slope_format <- c(all_full_time[[8,3]],all_full_time[[8,4]],all_full_time[[8,5]])
slope_format <- c(sum(all_full_time$mean_2020), sum(all_full_time$mean_2035), sum(all_full_time$mean_2050))

counts <- c(138862.8,146972.9,152162.6)
plot(years, counts)
plot(predict(lm(c(138862.8,146972.9,152162.6)~c(2020, 2035, 2050))))
lines(predict(lm(c(138862.8,146972.9,152162.6)~c(2020, 2035, 2050))),col='red')
points(all_full_time_pd[1,2:4], pch=19, col = "#355070")
points(randolph_full_time$mean_2050, pch=19, col = "#6d597a")
axis(1, at = 1:9, labels = randolph_stoch_count_2020$zone_name, las = 2)
arrows(1:9, as.integer(randolph_full_time$mean_2020)-as.integer(randolph_full_time$sd_2020), 1:9, as.integer(randolph_full_time$mean_2020)+as.integer(randolph_full_time$sd_2020), length=0.05, angle=90, code=3)


## Plot proportions
# Plot three times on one plot - zones
par(mar=c(15, 5, 2, 15) + 0.1, bg = "#ffffff", xpd=T)
years <- c(2020, 2035, 2050)
plot(x = years, y = all_full_time_proportion[1,3:5],
     ylim = (range(c(min(all_full_time_proportion[,3:5]), max(all_full_time_proportion[,3:5])))),
     pch=19,  ylab="Proportion of Developed Cells", xlab = "years", col = "#ff8989",
     xaxt = "n", yaxt = "n", type = "b"
)
points(x = years, y = all_full_time_proportion[2,3:5], pch=19, col = "#355070", type = "b")
points(x = years, y = all_full_time_proportion[3,3:5], pch=19, col = "#b56576", type = "b")
points(x = years, y = all_full_time_proportion[5,3:5], pch=19, col = "#eaac8b", type = "b")
points(x = years, y = all_full_time_proportion[6,3:5], pch=19, col = "#392942", type = "b")
points(x = years, y = all_full_time_proportion[7,3:5], pch=19, col = "#8b7696", type = "b")
points(x = years, y = all_full_time_proportion[8,3:5], pch=19, col = "#a997b2", type = "b")
points(x = years, y = all_full_time_proportion[9,3:5], pch=19, col = "#c8bace", type = "b")
axis(1, at = years, labels = years)
axis(2, at =seq.int(0, 0.35, by=0.05), labels = seq.int(0, 0.35, by=0.05))
legend("topright", inset=c(-1.2,0), legend = all_full_time_proportion[c(1:3,5:9),]$V2, pch = 19, col = c("#ff8989", "#355070", "#b56576", "#eaac8b", "#392942", "#8b7696", "#a997b2", "#c8bace"))

# Plot three times on one plot pd
par(mar=c(15, 5, 2, 15) + 0.1, bg = "#ffffff")
# years <- c(2020, 2035, 2050)
plot(x = years, y = all_full_time_pd_proportion[1,2:4],
     ylim = (range(c(min(all_full_time_pd_proportion[,2:4]), max(all_full_time_pd_proportion$mean_2050)))),
     pch=19,  ylab="Proportion of Developed Cells", xlab = "years", col = "#c9aadc",
     xaxt = "n", yaxt = "n",  type = "b"
)
points(x = years, y = all_full_time_pd_proportion[2,2:4], pch=19, col = "#b294c6", type = "b")
points(x = years, y = all_full_time_pd_proportion[3,2:4], pch=19, col = "#9b7faf", type = "b")
points(x = years, y = all_full_time_pd_proportion[4,2:4], pch=19, col = "#846b99", type = "b")
points(x = years, y = all_full_time_pd_proportion[5,2:4], pch=19, col = "#715683", type = "b")
points(x = years, y = all_full_time_pd_proportion[6,2:4], pch=19, col = "#715683", type = "b")
points(x = years, y = all_full_time_pd_proportion[7,2:4], pch=19, col = "#5b436f", type = "b")
points(x = years, y = all_full_time_pd_proportion[8,2:4], pch=19, col = "#5b436f", type = "b")
points(x = years, y = all_full_time_pd_proportion[9,2:4], pch=19, col = "#47315b", type = "b")
points(x = years, y = all_full_time_pd_proportion[10,2:4], pch=19, col = "#47315b", type = "b")
points(x = years, y = all_full_time_pd_proportion[11,2:4], pch=19, col = "#322048", type = "b")
points(x = years, y = all_full_time_pd_proportion[12,2:4], pch=19, col = "black", type = "b")

axis(1, at = years, labels = years)
axis(2, at =seq.int(0, 0.35, by=0.05), labels = seq.int(0, 0.35, by=0.05))
legend("topright", inset=c(-0.4,0), legend = all_full_time_pd_proportion$V1, pch = 19, col = c("#c9aadc", "#b294c6", "#9b7faf", "#846b99", "#715683", "#715683", "#5b436f", "#5b436f", "#47315b", "#47315b", "#322048", "#322048"))


# # Plotting with break axis -org (not function)
# par(mar=c(15, 5, 2, 2) + 0.1, bg = "#ffffff")
# y_tic <- c(seq.int(500, 25000, by=1000), seq.int(130000, 146000, by=1000))
# # ylab <- c("500", "4500", "9500", "14500", "19500", "130000", "140000", "145000")
# gap.plot( randolph_full_time$mean_2020, gap=c(25000, 130000), col = "#b56576",
#           pch=19, ylab="average number of developed cells", xlab = "", xtics = F, ytics =y_tic, yticlab = y_tic,
#           ylim = range(c(randolph_full_time$mean_2020-randolph_full_time$sd_2020,
#                          randolph_full_time$mean_2050+randolph_full_time$sd_2050)))
# axis.break(2, 25000*(1+0.02), breakcol="black", style="slash")
# axis.break(4, 25000*(1+0.02), breakcol="black", style="slash")
# gap.plot( randolph_full_time$mean_2035, gap=c(25000, 130000), col = "#355070",
#           pch=19, add = T )
# gap.plot( randolph_full_time$mean_2050, gap=c(25000, 130000), col = "#eaac8b",
#           pch=19, add = T )
# legend("topleft", legend = c(2050, 2035, 2020), pch = 19, col = c("#eaac8b", "#355070", "#b56576"))
# axis(1, at = 1:9, labels = randolph_stoch_count_2020$zone_name, las = 2)
# arrows(1:9, randolph_full_time$mean_2020-randolph_full_time$sd_2020, 1:9, randolph_full_time$mean_2020+randolph_full_time$sd_2020, length=0.05, angle=90, code=3)
# arrows(1:9, randolph_full_time$mean_2035-randolph_full_time$sd_2035, 1:9, randolph_full_time$mean_2035+randolph_full_time$sd_2035, length=0.05, angle=90, code=3)
# arrows(1:9, randolph_full_time$mean_2050-randolph_full_time$sd_2050, 1:9, randolph_full_time$mean_2050+randolph_full_time$sd_2050, length=0.05, angle=90, code=3)
# 
# # have to subtract gap to get the arrows to print correctly
# arrows(8, (max(randolph_full_time$mean_2020-randolph_full_time$sd_2020) - 105000), 8, (max(randolph_full_time$mean_2020+randolph_full_time$sd_2020) - 105000), length=0.05, angle=90, code=3)
# arrows(8, (max(randolph_full_time$mean_2035-randolph_full_time$sd_2035) - 105000), 8, (max(randolph_full_time$mean_2035+randolph_full_time$sd_2035) - 105000), length=0.05, angle=90, code=3)
# arrows(8, (max(randolph_full_time$mean_2050-randolph_full_time$sd_2050) - 105000), 8, (max(randolph_full_time$mean_2050+randolph_full_time$sd_2050) - 105000), length=0.05, angle=90, code=3)


# Plotting with break axis - function
# y_tic <- c(seq.int(min(county_full_time$mean_2020)-100, min_gap, by=1000), seq.int(max_gap, max(county_full_time$mean_2050)+1000, by=1000))

plot_break <- function(county_full_time, min_gap, max_gap, y_tic) {
  par(mar=c(15, 5, 2, 2) + 0.1, bg = "#ffffff")
  gap.plot( county_full_time$mean_2020, gap=c(min_gap, max_gap), col = "#b56576",
            pch=19, ylab="average number of developed cells", xlab = "", xtics = F, ytics =y_tic, yticlab = y_tic,
            ylim = range(c(county_full_time$mean_2020-county_full_time$sd_2020,
                           county_full_time$mean_2050+county_full_time$sd_2050)))
  axis.break(2, min_gap*(1+0.02), breakcol="black", style="slash")
  axis.break(4, min_gap*(1+0.02), breakcol="black", style="slash")
  gap.plot( county_full_time$mean_2035, gap=c(min_gap, max_gap), col = "#355070",
            pch=19, add = T )
  gap.plot( county_full_time$mean_2050, gap=c(min_gap, max_gap), col = "#eaac8b",
            pch=19, add = T )
  legend("topleft", legend = c(2050, 2035, 2020), pch = 19, col = c("#eaac8b", "#355070", "#b56576"))
  axis(1, at = 1:9, labels = randolph_stoch_count_2020$zone_name, las = 2)
  arrows(1:9, county_full_time$mean_2020-county_full_time$sd_2020, 1:9, county_full_time$mean_2020+county_full_time$sd_2020, length=0.05, angle=90, code=3)
  arrows(1:9, county_full_time$mean_2035-county_full_time$sd_2035, 1:9, county_full_time$mean_2035+county_full_time$sd_2035, length=0.05, angle=90, code=3)
  arrows(1:9, county_full_time$mean_2050-county_full_time$sd_2050, 1:9, county_full_time$mean_2050+county_full_time$sd_2050, length=0.05, angle=90, code=3)
  
  # have to subtract gap to get the arrows to print correctly
  arrows(8, (max(county_full_time$mean_2020-county_full_time$sd_2020) - (max_gap-min_gap)), 8, (max(county_full_time$mean_2020+county_full_time$sd_2020) - (max_gap-min_gap)), length=0.05, angle=90, code=3)
  arrows(8, (max(county_full_time$mean_2035-county_full_time$sd_2035) - (max_gap-min_gap)), 8, (max(county_full_time$mean_2035+county_full_time$sd_2035) - (max_gap-min_gap)), length=0.05, angle=90, code=3)
  arrows(8, (max(county_full_time$mean_2050-county_full_time$sd_2050) - (max_gap-min_gap)), 8, (max(county_full_time$mean_2050+county_full_time$sd_2050) - (max_gap-min_gap)), length=0.05, angle=90, code=3)
  
}


plot_no_break <- function(county_full_time) {
  par(mar=c(15, 5, 2, 2) + 0.1, bg = "#ffffff")
  plot(county_full_time$mean_2020,
       ylim=range(c(county_full_time$mean_2050-county_full_time$sd_2050, county_full_time$mean_2050+county_full_time$sd_2050)),
       pch=19,  ylab="average number of developed cells", xlab = "", col = "#b56576",
      xaxt = "n"
  )
  points(county_full_time$mean_2035, pch=19, col = "#355070")
  points(county_full_time$mean_2050, pch=19, col = "#eaac8b")
  legend("topleft", legend = c(2050, 2035, 2020), pch = 19, col = c("#eaac8b", "#355070", "#b56576"))
  axis(1, at = 1:9, labels = randolph_stoch_count_2020$zone_name, las = 2)
  #arrows(1:9, county_full_time$mean_2020-county_full_time$sd_2020, 1:9, county_full_time$mean_2020+county_full_time$sd_2020, length=0.05, angle=90, code=3)
  #arrows(1:9, county_full_time$mean_2035-county_full_time$sd_2035, 1:9, county_full_time$mean_2035+county_full_time$sd_2035, length=0.05, angle=90, code=3)
  #arrows(1:9, county_full_time$mean_2050-county_full_time$sd_2050, 1:9, county_full_time$mean_2050+county_full_time$sd_2050, length=0.05, angle=90, code=3)
  
}

plot_no_break_pd <- function(county_full_time) {
  par(mar=c(15, 5, 2, 2) + 0.1, bg = "#ffffff")
  plot(county_full_time$mean_2020,
       ylim=range(c(county_full_time$mean_2050-county_full_time$sd_2050, county_full_time$mean_2050+county_full_time$sd_2050)),
       pch=19,  ylab="average number of developed cells", xlab = "Population Density", col = "#b56576", xaxt = "n"
  )
  points(county_full_time$mean_2035, pch=19, col = "#355070")
  points(county_full_time$mean_2050, pch=19, col = "#eaac8b")
  legend("topright", legend = c(2050, 2035, 2020), pch = 19, col = c("#eaac8b", "#355070", "#b56576"))
  axis(1, at = 1:12, labels = county_full_time$V1, las=2)
  # arrows(1:12, county_full_time$mean_2020-county_full_time$sd_2020, 1:12, county_full_time$mean_2020+county_full_time$sd_2020, length=0.05, angle=90, code=3)
  # arrows(1:12, county_full_time$mean_2035-county_full_time$sd_2035, 1:12, county_full_time$mean_2035+county_full_time$sd_2035, length=0.05, angle=90, code=3)
  # arrows(1:12, county_full_time$mean_2050-county_full_time$sd_2050, 1:12, county_full_time$mean_2050+county_full_time$sd_2050, length=0.05, angle=90, code=3)
  
}

plot_break_pd <- function(county_full_time, min_gap, max_gap, y_tic) {
  par(mar=c(15, 5, 2, 2) + 0.1, bg = "#ffffff")
  gap.plot( county_full_time$mean_2020, gap=c(min_gap, max_gap), col = "#b56576",
            pch=19, ylab="average number of developed cells", xlab = "Population Density", xtics = F, ytics =y_tic, yticlab = y_tic,
            ylim = range(c(county_full_time$mean_2020-county_full_time$sd_2020,
                           county_full_time$mean_2050+county_full_time$sd_2050)))
  axis.break(2, min_gap*(1+0.02), breakcol="black", style="slash")
  axis.break(4, min_gap*(1+0.02), breakcol="black", style="slash")
  gap.plot( county_full_time$mean_2035, gap=c(min_gap, max_gap), col = "#355070",
            pch=19, add = T )
  gap.plot( county_full_time$mean_2050, gap=c(min_gap, max_gap), col = "#eaac8b",
            pch=19, add = T )
  legend("topright", legend = c(2050, 2035, 2020), pch = 19, col = c("#eaac8b", "#355070", "#b56576"))
  axis(1, at = 1:12, labels = county_full_time$V1, las =2)

}

# Randolph
y_tic <- c(seq.int(500, 25000, by=1000), seq.int(130000, 146000, by=1000))
plot_break(randolph_full_time, 25000, 130000, y_tic)

y_tic <- c(seq.int(250, 67500, by=1000), seq.int(150000, 170000, by=5000))
plot_no_break_pd(randolph_full_time_pd)
# plot_break_pd(randolph_full_time_pd, 68000, 150000,y_tic )

# Harnett
plot_no_break(harnett_full_time)
plot_no_break_pd(harnett_full_time_pd)

#Wake
plot_no_break(wake_full_time)

plot_no_break_pd(wake_full_time_pd)

# All
par(mar=c(15, 5, 2, 2) + 0.1, bg = "#ffffff")
plot(all_full_time$mean_2020,
     ylim=range(c(min(all_full_time$mean_2050), max(all_full_time$mean_2050))),
     pch=19,  ylab="average number of developed cells", xlab = "", col = "#b56576",
      xaxt = "n"
)
points(all_full_time$mean_2035, pch=19, col = "#355070")
points(all_full_time$mean_2050, pch=19, col = "#eaac8b")
legend("topleft", legend = c(2050, 2035, 2020), pch = 19, col = c("#eaac8b", "#355070", "#b56576"))
axis(1, at = 1:9, labels = randolph_stoch_count_2020$zone_name, las = 2)

par(mar=c(15, 5, 2, 2) + 0.1, bg = "#ffffff")
plot(all_full_time_pd$mean_2020,
     ylim=range(c(min(all_full_time_pd$mean_2050), max(all_full_time_pd$mean_2050))),
     pch=19,  ylab="average number of developed cells", xlab = "Population Density", col = "#b56576",
     xaxt = "n"
)
points(all_full_time_pd$mean_2035, pch=19, col = "#355070")
points(all_full_time_pd$mean_2050, pch=19, col = "#eaac8b")
legend("topright", legend = c(2050, 2035, 2020), pch = 19, col = c("#eaac8b", "#355070", "#b56576"))
axis(1, at = 1:12, labels = all_full_time_pd$V1, las=2)

# legend prop
# 0.0,0.5,1.0,1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.0,6.5
# pd d.legend -t -b raster=pd_dev_wake_2050_1@zones labelnum=2 range=0,6.5 border_color=none
# zone d.legend raster=zone_dev_wake_2050_1@zones use=1,2,3,5,7,8 border_color=none
# FUTURES d.legend -b raster=out_seed_1_SSP2@PERMANENT use=-1,0,4,19,40 border_color=none