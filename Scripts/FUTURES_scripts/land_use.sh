#!/bin/tcsh
#BSUB -n 3
#BSUB -W 3:00
#BSUB -R "rusage[mem=1GB]"
#BSUB -oo landuse_out
#BSUB -eo landuse_err
#BSUB -J landuse

module use --append /usr/local/usrapps/geospatial/modulefiles
module load grass/8.1

# TODO check parenthesis placement #
# extract urban land use categories from all NLCD
grass -c /share/rkmeente/malawrim/grassdata/PERMANENT/urban_2001 --exec r.mapcalc "urban_2001 = if(roads , null(), if(nlcd_2001 >= 21 && nlcd_2001 <= 24, 1, if(nlcd_2001 == 11 || nlcd_2001 >= 90 || protected, null(), 0)))" --overwrite &
grass -c /share/rkmeente/malawrim/grassdata/PERMANENT/urban_2004 --exec r.mapcalc "urban_2004 = if(roads , null(), if(nlcd_2004 >= 21 && nlcd_2004 <= 24, 1, if(nlcd_2004 == 11 || nlcd_2004 >= 90 || protected, null(), 0)))" --overwrite &
grass -c /share/rkmeente/malawrim/grassdata/PERMANENT/urban_2006 --exec r.mapcalc "urban_2006 = if(roads , null(), if(nlcd_2006 >= 21 && nlcd_2006 <= 24, 1, if(nlcd_2006 == 11 || nlcd_2006 >= 90 || protected, null(), 0)))" --overwrite &
grass -c /share/rkmeente/malawrim/grassdata/PERMANENT/urban_2008 --exec r.mapcalc "urban_2008 = if(roads , null(), if(nlcd_2008 >= 21 && nlcd_2008 <= 24, 1, if(nlcd_2008 == 11 || nlcd_2008 >= 90 || protected, null(), 0)))" --overwrite &
grass -c /share/rkmeente/malawrim/grassdata/PERMANENT/urban_2011 --exec r.mapcalc "urban_2011 = if(roads , null(), if(nlcd_2011 >= 21 && nlcd_2011 <= 24, 1, if(nlcd_2011 == 11 || nlcd_2011 >= 90 || protected, null(), 0)))" --overwrite &
grass -c /share/rkmeente/malawrim/grassdata/PERMANENT/urban_2013 --exec r.mapcalc "urban_2013 = if(roads , null(), if(nlcd_2013 >= 21 && nlcd_2013 <= 24, 1, if(nlcd_2013 == 11 || nlcd_2013 >= 90 || protected, null(), 0)))" --overwrite &
grass -c /share/rkmeente/malawrim/grassdata/PERMANENT/urban_2016 --exec r.mapcalc "urban_2016 = if(roads , null(), if(nlcd_2016 >= 21 && nlcd_2016 <= 24, 1, if(nlcd_2016 == 11 || nlcd_2016 >= 90 || protected, null(), 0)))" --overwrite &
grass -c /share/rkmeente/malawrim/grassdata/PERMANENT/urban_2019 --exec r.mapcalc "urban_2019 = if(roads , null(), if(nlcd_2019 >= 21 && nlcd_2019 <= 24, 1, if(nlcd_2019 == 11 || nlcd_2019 >= 90 || protected, null(), 0)))" --overwrite &

grass -c /share/rkmeente/malawrim/grassdata/PERMANENT/water --exec r.mapcalc "water = if(nlcd_2011 == 11, 1, null())" &

grass -c /share/rkmeente/malawrim/grassdata/PERMANENT/forest_2001 --exec r.mapcalc "forest_2001 = if(nlcd_2001 >= 41 && nlcd_2001 <= 43, 1, 0)" &
grass -c /share/rkmeente/malawrim/grassdata/PERMANENT/forest_2008 --exec r.mapcalc "forest_2008 = if(nlcd_2008 >= 40 && nlcd_2008 <= 43, 1, 0)" &

grass -c /share/rkmeente/malawrim/grassdata/PERMANENT/forest_2008_smooth --exec r.neighbors -c input=forest_2008 output=forest_2008_smooth size=15 method=average
grass -c /share/rkmeente/malawrim/grassdata/PERMANENT/forest_2001_smooth --exec r.neighbors -c input=forest_2001 output=forest_2001_smooth size=15 method=average
grass -c /share/rkmeente/malawrim/grassdata/PERMANENT/road_dens --exec r.neighbors -c input=roads output=road_dens size=25 method=average

r.mapcalc "urban_2011 = if(roads , null(), if(nlcd_2011 >= 21 && nlcd_2011 <= 24, 1, if(nlcd_2011 == 11 || nlcd_2011 >= 90 || protected, null(), 0)))" --overwrite

