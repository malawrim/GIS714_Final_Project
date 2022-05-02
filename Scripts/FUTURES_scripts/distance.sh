#!/bin/tcsh
#BSUB -n 5
#BSUB -W 1:00
#BSUB -R "rusage[mem=1GB]"
#BSUB -oo dist_out
#BSUB -eo dist_err
#BSUB -J dist

module use --append /usr/local/usrapps/geospatial/modulefiles
module load grass/8.1

rm -rf /share/rkmeente/malawrim/grassdata/futures_pop_dens/roads
rm -rf /share/rkmeente/malawrim/grassdata/futures_pop_dens/water
rm -rf /share/rkmeente/malawrim/grassdata/futures_pop_dens/forest
rm -rf /share/rkmeente/malawrim/grassdata/futures_pop_dens/city_center
rm -rf /share/rkmeente/malawrim/grassdata/futures_pop_dens/protected

# run in background by appending & after the tool

# fix 0 values
grass -c /share/rkmeente/malawrim/grassdata/futures_pop_dens/roads --exec r.mapcalc "roads_null = if(roads == 0, null(), 1)"
grass -c /share/rkmeente/malawrim/grassdata/futures_pop_dens/water --exec r.mapcalc "water_null = if(water == 0, null(), 1)"
grass -c /share/rkmeente/malawrim/grassdata/futures_pop_dens/forest --exec r.mapcalc "forest_null = if(forest_2011 == 0, null(), 1)"
grass -c /share/rkmeente/malawrim/grassdata/futures_pop_dens/city_center --exec r.mapcalc "sa_city_null = if(sa_city_center == 0, null(), 1)"
grass -c /share/rkmeente/malawrim/grassdata/futures_pop_dens/protected --exec r.mapcalc "protected_null = if(protected == 0, null(), 1)"

wait
grass /share/rkmeente/malawrim/grassdata/futures_pop_dens/roads --exec r.grow.distance input=roads_null distance=dist_to_roads -m &
grass /share/rkmeente/malawrim/grassdata/futures_pop_dens/water --exec r.grow.distance input=water_null distance=dist_to_water -m &
grass /share/rkmeente/malawrim/grassdata/futures_pop_dens/forest --exec r.grow.distance input=forest_null distance=dist_to_forest -m &
grass /share/rkmeente/malawrim/grassdata/futures_pop_dens/city_center --exec r.grow.distance input=sa_city_null  distance=US_city_center_dist -m &
grass /share/rkmeente/malawrim/grassdata/futures_pop_dens/protected --exec r.grow.distance input=protected_null distance=dist_to_protected -m &

# this will wait for the processes to finish before starting the next set of processes
wait
grass /share/rkmeente/malawrim/grassdata/futures_pop_dens/roads --exec r.mapcalc "log_dist_to_roads = log(dist_to_roads + 1)" &
grass /share/rkmeente/malawrim/grassdata/futures_pop_dens/water --exec r.mapcalc "log_dist_to_water = log(dist_to_water + 1)" &
grass /share/rkmeente/malawrim/grassdata/futures_pop_dens/forest --exec r.mapcalc "log_dist_to_forest = log(dist_to_forest + 1)" &
grass /share/rkmeente/malawrim/grassdata/futures_pop_dens/city_center --exec r.mapcalc "US_city_center_dist_log = float(if (US_city_center_dist > 0, log(US_city_center_dist), 0))" &
grass /share/rkmeente/malawrim/grassdata/futures_pop_dens/protected --exec r.mapcalc "dist_to_protected_log = float(if (dist_to_protected > 0, log(dist_to_protected), 0))" &
wait

