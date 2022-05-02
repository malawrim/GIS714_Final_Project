#!/bin/tcsh
#BSUB -n 1
#BSUB -W 1:00
#BSUB -R span[hosts=1]
#BSUB -R "rusage[mem=2GB]"
#BSUB -oo demand_out
#BSUB -eo demand_err
#BSUB -J demand

module use --append /usr/local/usrapps/geospatial/modulefiles
module load grass/8.1

grass /share/rkmeente/malawrim/grassdata/futures_pop_dens/PERMANENT --exec r.mask raster=roads maskcats=0

# Demand
grass /share/rkmeente/malawrim/grassdata/futures_pop_dens/PERMANENT --exec r.futures.demand development=urban_2001,urban_2004,urban_2006,urban_2008 subregions=counties observed_population=/share/rkmeente/malawrim/ex_pop_hist.csv projected_population=/share/rkmeente/malawrim/ex_pop_proj.csv simulation_times=2008,2009,2010,2011,2012,2013,2014,2015,2016,2017,2018,2019,2020,2021,2022,2023,2024,2025,2026,2027,2028,2029,2030,2031,2032,2033,2034,2035 plot=/share/rkmeente/malawrim/plot_demand.pdf demand=/share/rkmeente/malawrim/demand.csv separator=comma method=logarithmic

# remove mask
grass /share/rkmeente/malawrim/grassdata/futures_pop_dens/PERMANENT --exec r.mask -r
