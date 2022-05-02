#!/bin/tcsh
#BSUB -n 1
#BSUB -W 1:00
#BSUB -R span[hosts=1]
#BSUB -R "rusage[mem=2GB]"
#BSUB -oo sample_out
#BSUB -eo sample_err
#BSUB -J sampling

module use --append /usr/local/usrapps/geospatial/modulefiles
module load grass/8.1

rm -rf /share/rkmeente/malawrim/grassdata/futures_pop_dens/urban

grass -c /share/rkmeente/malawrim/grassdata/futures_pop_dens/urban --exec r.mapcalc "urban_change_01_11 = if(urban_2011 == 1, if(urban_2001 == 0, 1, null()), 0)"
grass /share/rkmeente/malawrim/grassdata/futures_pop_dens/urban --exec r.mapcalc "urban_change_clip = if(counties, urban_change_01_11)"

grass /share/rkmeente/malawrim/grassdata/futures_pop_dens/urban --exec r.sample.category input=urban_change_clip@urban output=sampling sampled=counties@PERMANENT,devpressure_2001@devpressure_2001,slope@PERMANENT,road_dens@PERMANENT,forest_2001_smooth@PERMANENT,log_dist_to_water@water,dist_to_protected_log@protected,US_city_center_dist_log@city_center npoints=5000,1000 random_seed=42