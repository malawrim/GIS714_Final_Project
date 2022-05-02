#!/bin/tcsh
#BSUB -n 8
#BSUB -W 10:00
#BSUB -R span[hosts=1]
#BSUB -R "rusage[mem=2GB]"
#BSUB -oo devpot_out
#BSUB -eo devpot_err
#BSUB -J devpotential

module use --append /usr/local/usrapps/geospatial/modulefiles
module load grass/8.1
module load R

# grass /share/rkmeente/malawrim/grassdata/futures_pop_dens/PERMANENT --exec r.futures.potential -d input=sampling@urban output=potential.csv columns=counties@PERMANENT,devpressure_2001@devpressure_2001,slope@PERMANENT,road_dens@PERMANENT,forest_2001_smooth@PERMANENT,log_dist_to_water@water,dist_to_protected_log@protected,US_city_center_dist_log@city_center developed_column=urban_change_clip@urban subregions_column=counties@PERMANENT min_variables=4 nprocs=8
grass /share/rkmeente/malawrim/grassdata/futures_pop_dens/PERMANENT --exec r.futures.potential -d input=sampling@urban output=potential.csv columns=counties,devpressure_2001,slope,road_dens,forest_2001_smooth,log_dist_to_water,dist_to_protected_log,us_city_center_dist_log developed_column=urban_change_clip subregions_column=counties min_variables=4 nprocs=8

# library("devtools")
# install_github("lme4/lme4",dependencies=TRUE)