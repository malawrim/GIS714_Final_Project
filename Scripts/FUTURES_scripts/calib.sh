#!/bin/tcsh
#BSUB -n 8
#BSUB -W 1:00
#BSUB -R span[hosts=1]
#BSUB -R "rusage[mem=2GB]"
#BSUB -oo calib_out
#BSUB -eo calib_err
#BSUB -J calib

module use --append /usr/local/usrapps/geospatial/modulefiles
module load grass/8.1

grass /share/rkmeente/malawrim/grassdata/futures_pop_dens/PERMANENT --exec g.region raster=counties zoom=counties

#derive patches
grass /share/rkmeente/malawrim/grassdata/futures_pop_dens/PERMANENT --exec r.futures.calib development_start=urban_2001 development_end=urban_2008 subregions=counties patch_sizes=/share/rkmeente/malawrim/patches.txt patch_threshold=1800 nprocs=8 -l --overwrite
wait

grass /share/rkmeente/malawrim/grassdata/futures_pop_dens/PERMANENT --exec r.futures.calib development_start=urban_2001 development_end=urban_2008 subregions=counties patch_sizes=/share/rkmeente/malawrim/patches.txt calibration_results=/share/rkmeente/malawrim/calib.csv patch_threshold=1800 repeat=10 compactness_mean=0.1,0.3,0.5,0.7,0.9 compactness_range=0.05 discount_factor=0.1,0.3,0.5,0.7,0.9 predictors=road_dens@PERMANENT,forest_2008_smooth@PERMANENT,log_dist_to_water@water,US_city_center_dist_log@city_center demand=/share/rkmeente/malawrim/demand.csv devpot_params=/share/rkmeente/malawrim/potential.csv num_neighbors=4 seed_search=probability development_pressure=devpressure_2008@devpressure_2008 development_pressure_approach=gravity n_dev_neighbourhood=30 gamma=0.5 scaling_factor=0.1 nprocs=8 --overwrite

grass /share/rkmeente/malawrim/grassdata/futures_pop_dens/PERMANENT --exec r.futures.calib development_start=urban_2001 \
 development_end=urban_2008 \
 subregions=counties \
 patch_sizes=/share/rkmeente/malawrim/patches.txt \
 calibration_results=/share/rkmeente/malawrim/calib.csv \
 patch_threshold=1800 \
 repeat=10 \
 compactness_mean=0.1,0.3,0.5,0.7,0.9 \
 compactness_range=0.05 \
 discount_factor=0.1,0.3,0.5,0.7,0.9 \
 predictors=road_dens@PERMANENT,forest_2008_smooth@PERMANENT,log_dist_to_water@water,US_city_center_dist_log@city_center \
 demand=/share/rkmeente/malawrim/demand.csv devpot_params=/share/rkmeente/malawrim/potential.csv
 num_neighbors=4 \
 seed_search=probability \
 development_pressure=devpressure_2008@devpressure_2008 \
 development_pressure_approach=gravity \
 n_dev_neighbourhood=30 \
 gamma=0.5 \
 scaling_factor=0.1 \
 nprocs=8 --overwrite