#!/bin/tcsh
#BSUB -n 16
#BSUB -W 10:00
#BSUB -R span[hosts=1]
#BSUB -R "rusage[mem=2GB]"
#BSUB -oo devpressure_out
#BSUB -eo devpressure_err
#BSUB -J devpressure

module use --append /usr/local/usrapps/geospatial/modulefiles
module load grass/8.1

rm -rf /share/rkmeente/malawrim/grassdata/futures_pop_dens/devpressure_2001
rm -rf /share/rkmeente/malawrim/grassdata/futures_pop_dens/devpressure_2008
# rm -rf /share/rkmeente/malawrim/grassdata/futures_pop_dens/devpressure_2019

# run in background by appending & after the tool
grass -c /share/rkmeente/malawrim/grassdata/futures_pop_dens/devpressure_2001 --exec r.futures.devpressure input=urban_2001 output=devpressure_2001 size=20 gamma=1 nprocs=8 &
grass -c /share/rkmeente/malawrim/grassdata/futures_pop_dens/devpressure_2008 --exec r.futures.devpressure input=urban_2008 output=devpressure_2008 size=20 gamma=1 nprocs=8 &
# grass -c /share/rkmeente/malawrim/grassdata/futures_pop_dens/devpressure_2019 --exec r.futures.devpressure input=urban_2019 output=devpressure_2019 size=20 gamma=1 nprocs=8 &

# this will wait for the processes to finish
wait