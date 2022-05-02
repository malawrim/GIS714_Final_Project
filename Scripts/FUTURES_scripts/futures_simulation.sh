#!/bin/tcsh
#BSUB -n 1
#BSUB -W 1:00
#BSUB -R span[hosts=1]
#BSUB -R "rusage[mem=2GB]"
#BSUB -oo pga_out
#BSUB -eo pga_err
#BSUB -J pga

module use --append /usr/local/usrapps/geospatial/modulefiles
module load grass/8.1

grass /share/rkmeente/malawrim/grassdata/futures_pop_dens/PERMANENT --exec g.region vector=counties align=nlcd_2011@PERMANENT -p

grass /share/rkmeente/malawrim/grassdata/futures_pop_dens/PERMANENT --exec r.futures.pga subregions=counties developed=urban_2008 predictors=road_dens@PERMANENT,forest_2008_smooth@PERMANENT,log_dist_to_water@water,US_city_center_dist_log@city_center devpot_params=/share/rkmeente/malawrim/potential.csv \
 development_pressure=devpressure_2008@devpressure_2008 n_dev_neighbourhood=30 development_pressure_approach=gravity gamma=0.5 scaling_factor=0.1 demand=/share/rkmeente/malawrim/demand.csv \
 discount_factor=0.1 compactness_mean=0.1 compactness_range=0.05 patch_sizes=/share/rkmeente/malawrim/patches.txt num_neighbors=4 seed_search=probability random_seed=1 output=final output_series=step