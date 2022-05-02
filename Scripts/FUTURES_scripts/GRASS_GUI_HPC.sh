# See GRASS GUI in interactive HPC

# to start interactive session
bsub -Is -n 1 -R "rusage[mem=2GB]" -W 30 tcsh

# In interactive session
module use --append /usr/local/usrapps/geospatial/modulefiles
module load grass/8.1

# set location
grass /share/gis714s22/$USER/grassdata/intro/PERMANENT

# set region
g.region n=1690185 s=252165 e=1838925 w=514635 res=30 -p

# launch GUI
# have to redo every time you switch mapsets
d.mon wx0

# to display
d.rast nlcd_2019

exit