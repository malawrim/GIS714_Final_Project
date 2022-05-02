# set location
# grass -c EPSG:6346 -e ~/grassdata/dix_park/ 

# set working directory

# region of interest
v.import --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\county_boundary\Example_Counties.shp layer=Example_Counties output=Example_Counties

# set region
# get full extent for Harnett Region
g.region -p -a vector=Example_Counties@PERMANENT
v.in.region --overwrite output=Example_Counties_region
v.to.rast --overwrite input=Example_Counties_region@PERMANENT type=area output=Example_Counties_rast use=cat
#### Double check about adding res attribute #####
g.region raster=Example_Counties_rast

# Import predictors (vector)
# roads
v.import --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\Tigers_Road_State_2016\37\tl_2016_37_roads.shp output=roads

# interchanges
# v.import --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\interchanges\tl_2016_cont_us_psroads_intsct_all.shp output=interchange

# protected areas
# v.import --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\protected_areas\PAD_US2_1.gdb layer=PADUS2_1Combined_Proclamation_Marine_Fee_Designation_Easement output=protected
# Cropped to NC for space
v.import --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\protected_areas\protected_nc.shp output=protected

# census places
v.import --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\cities\tl_2021_37_place.shp output=census_places

# census metropolitan areas
v.import --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\cities\2019_us_metropolitan_statistical_area.shp output=metro_area

# builiding height
v.import --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\building_height_national\srtm_derived_building_heights_by_block_group_conterminous_US\srtm_bg_building_heights.gdb layer=srtm_bldg_heights_class output=building_ht
# takes a long time to load national file so clipped to NC
# v.import --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\building_height_national\NC_building_height.shp output=building_ht

# census block data for population data (from csv)
v.import --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\census_block\census_block.shp output=census_bloc

# Lakes
v.import --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\water\lakes.shp output=lakes

# streams
v.import --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\water\streams_rivers.shp output=streams_rivers


# Import predictors (raster)

# nlcd
r.import --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\nlcd2019\nlcd_nc.tif output=nlcd
# r.import --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\nlcd2019\nlcd_ex_r.tif output=nlcd_ex

# impervious
r.import --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\impervious\impervious_nc.tif output=impervious

# crop/agriculture data
r.import --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\crop\crop.tif output=agriculture
# r.import --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\crop\crop_clip.tif output=agriculture

# elevation

# import zoning data
# Randolph zones
# v.import --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\randolph_merge\randolph_merge.shp output=randolph_zoning
v.import --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\randolph_merge_id\randolph_merge_id.shp output=randolph_zoning

# Harnett zones
# v.import --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\merged_Harnett\merged_Harnett.shp output=harnett_zoning
v.import --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\merged_Harnett_id\merged_Harnett_id.shp output=harnett_zoning

# Wake county zones
v.import --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\merged_Wake_id\merged_Wake_id.shp output=wake_zoning

# we need to set the computational extent based on a vector map, but take the resolution and alignment from a raster map:
# g.region -p vector=roads align=dsm

# Road density
# see preprocessing.txt
r.import --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\Road_Density\NC_roadDen.tif output=road_density

# Building density
# see preprocessing.txt

# building density from point density tool
r.import --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\building_density\blg_density.tif output=blg_density

# fraction of total area covered by building footprints
v.import --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\building_density\blg_den_join.shp output=blg_area
v.to.rast --overwrite input=blg_footprint@PERMANENT type=area output=blg_rast use=cat

# Create binary building/no building layer
v.import --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\building_density\Building_footprint.shp output=blg_footprint
v.to.rast --overwrite input=blg_area@PERMANENT type=area output=blg_area_rast use=attr attribute_column=Blg_area label_column=Blg_area
# find distance from building
r.grow.distance --overwrite input=blg_area_rast@PERMANENT distance=dist_building


# distance to metro areas
# vector to raster
v.to.rast --overwrite input=metro_area@PERMANENT type=area output=metro_areas_rast@PERMANENT use=val
# distance
r.grow.distance --overwrite input=metro_areas_rast@PERMANENT distance=dist_metro_area

# distance to census place
# vector to raster
v.to.rast --overwrite input=census_places@PERMANENT type=area output=census_places_rast@PERMANENT use=val
# distance
r.grow.distance --overwrite input=census_places_rast@PERMANENT distance=dist_census_place

# distance to roads
# vector to raster
v.to.rast --overwrite input=roads@PERMANENT type=line output=road_rast@PERMANENT use=val
# distance
r.grow.distance --overwrite input=road_rast@PERMANENT distance=dist_road

# distance to interchange
# vector to raster
# v.to.rast --overwrite input=interchange@PERMANENT type=point output=interchange_rast use=attr attribute_column=Code
# distance
# r.grow.distance --overwrite input=interchange_rast@PERMANENT distance=dist_interchange

# distance to interchange
r.import --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\interchanges\dist_interch.tif output=dist_interchange


# distance to streams
# vector to raster
v.to.rast --overwrite input=streams_rivers@PERMANENT type=line output=stream_river_rast@PERMANENT use=val
# distance
r.grow.distance --overwrite input=stream_river_rast@PERMANENT distance=dist_river

# distance to lakes
# vector to raster
v.to.rast --overwrite input=lakes@PERMANENT type=area output=lake_rast@PERMANENT use=val
# distance
r.grow.distance --overwrite input=lake_rast@PERMANENT distance=dist_lake


# Distance to interstate
# extract interstate from complete roads file
# same problem with v.extract as in 714 hw
# Had to run in 7.8 and load into 8.0
v.extract input=roads@PERMANENT output=interstate where="RTTYP = 'I' OR RTTYP = 'U'"
# vector to raster
v.to.rast --overwrite input=interstate@PERMANENT type=line output=interstate_rast@PERMANENT use=val
# distance
r.grow.distance --overwrite input=interstate_rast@PERMANENT distance=dist_interstate

# Distance to Protected area
# vector to raster
v.to.rast --overwrite input=protected@PERMANENT type=area output=protected_rast@PERMANENT use=val
# distance
r.grow.distance --overwrite input=protected_rast@PERMANENT distance=dist_protected

# Reclass NLCD to 7 majors classes + all developed subclasses
r.reclass --overwrite input=nlcd@PERMANENT output=nlcd_reclass@PERMANENT rules=C:\RA\Zoning\nlcd_reclass.txt
# Check if reclass was successful
r.category nlcd_reclass

# elevation data
# all tiles in DEM folder

# import all using r.import with directory option
g.list -r type=raster pattern='USGS_13*'
# region for all of the tiles
# g.region raster=USGS_13_n34w078_20130911@PERMANENT,USGS_13_n34w079_20190913@PERMANENT,USGS_13_n35w077_20151130@PERMANENT,USGS_13_n35w078_20151130@PERMANENT,USGS_13_n35w079_20130911@PERMANENT,USGS_13_n35w080_20130911@PERMANENT,USGS_13_n37w077_20210610@PERMANENT,USGS_13_n37w077_20211220@PERMANENT,USGS_13_n37w078_20210305@PERMANENT,USGS_13_n37w078_20210610@PERMANENT,USGS_13_n37w079_20210305@PERMANENT,USGS_13_n37w080_20210305@PERMANENT,USGS_13_n37w081_20210305@PERMANENT,USGS_13_n37w082_20210305@PERMANENT,USGS_1_n34w078_20130911@PERMANENT,USGS_1_n34w079_20190913@PERMANENT,USGS_1_n35w077_20151130@PERMANENT,USGS_1_n35w078_20151130@PERMANENT,USGS_1_n35w079_20130911@PERMANENT,USGS_1_n35w080_20130911@PERMANENT,USGS_1_n35w081_20130911@PERMANENT,USGS_1_n35w083_20170309@PERMANENT,USGS_1_n35w084_20130911@PERMANENT,USGS_1_n35w085_20170824@PERMANENT,USGS_1_n36w076_20160315@PERMANENT,USGS_1_n36w077_20160315@PERMANENT,USGS_1_n36w078_20151125@PERMANENT,USGS_1_n36w079_20130911@PERMANENT,USGS_1_n36w080_20130911@PERMANENT,USGS_1_n36w081_20130911@PERMANENT,USGS_1_n36w082_20130911@PERMANENT,USGS_1_n36w083_20171114@PERMANENT,USGS_1_n36w084_20171109@PERMANENT,USGS_1_n36w085_20171101@PERMANENT,USGS_1_n37w076_20151106@PERMANENT,USGS_1_n37w077_20160315@PERMANENT,USGS_1_n37w077_20210610@PERMANENT,USGS_1_n37w077_20211220@PERMANENT,USGS_1_n37w078_20151109@PERMANENT,USGS_1_n37w078_20210305@PERMANENT,USGS_1_n37w078_20210610@PERMANENT,USGS_1_n37w079_20130911@PERMANENT,USGS_1_n37w079_20210305@PERMANENT,USGS_1_n37w080_20130911@PERMANENT,USGS_1_n37w080_20210305@PERMANENT,USGS_1_n37w081_20181203@PERMANENT,USGS_1_n37w081_20210305@PERMANENT,USGS_1_n37w082_20181127@PERMANENT,USGS_1_n37w082_20210305@PERMANENT,USGS_1_n37w083_20181127@PERMANENT
# instead use study area region
r.patch --overwrite in=USGS_13_n34w078_20130911@PERMANENT,USGS_13_n34w079_20190913@PERMANENT,USGS_13_n35w077_20151130@PERMANENT,USGS_13_n35w078_20151130@PERMANENT,USGS_13_n35w079_20130911@PERMANENT,USGS_13_n35w080_20130911@PERMANENT,USGS_13_n37w077_20210610@PERMANENT,USGS_13_n37w077_20211220@PERMANENT,USGS_13_n37w078_20210305@PERMANENT,USGS_13_n37w078_20210610@PERMANENT,USGS_13_n37w079_20210305@PERMANENT,USGS_13_n37w080_20210305@PERMANENT,USGS_13_n37w081_20210305@PERMANENT,USGS_13_n37w082_20210305@PERMANENT,USGS_1_n34w078_20130911@PERMANENT,USGS_1_n34w079_20190913@PERMANENT,USGS_1_n35w077_20151130@PERMANENT,USGS_1_n35w078_20151130@PERMANENT,USGS_1_n35w079_20130911@PERMANENT,USGS_1_n35w080_20130911@PERMANENT,USGS_1_n35w081_20130911@PERMANENT,USGS_1_n35w083_20170309@PERMANENT,USGS_1_n35w084_20130911@PERMANENT,USGS_1_n35w085_20170824@PERMANENT,USGS_1_n36w076_20160315@PERMANENT,USGS_1_n36w077_20160315@PERMANENT,USGS_1_n36w078_20151125@PERMANENT,USGS_1_n36w079_20130911@PERMANENT,USGS_1_n36w080_20130911@PERMANENT,USGS_1_n36w081_20130911@PERMANENT,USGS_1_n36w082_20130911@PERMANENT,USGS_1_n36w083_20171114@PERMANENT,USGS_1_n36w084_20171109@PERMANENT,USGS_1_n36w085_20171101@PERMANENT,USGS_1_n37w076_20151106@PERMANENT,USGS_1_n37w077_20160315@PERMANENT,USGS_1_n37w077_20210610@PERMANENT,USGS_1_n37w077_20211220@PERMANENT,USGS_1_n37w078_20151109@PERMANENT,USGS_1_n37w078_20210305@PERMANENT,USGS_1_n37w078_20210610@PERMANENT,USGS_1_n37w079_20130911@PERMANENT,USGS_1_n37w079_20210305@PERMANENT,USGS_1_n37w080_20130911@PERMANENT,USGS_1_n37w080_20210305@PERMANENT,USGS_1_n37w081_20181203@PERMANENT,USGS_1_n37w081_20210305@PERMANENT,USGS_1_n37w082_20181127@PERMANENT,USGS_1_n37w082_20210305@PERMANENT,USGS_1_n37w083_20181127@PERMANENT out=DEM
# Calculate slope
r.slope.aspect --overwrite elevation=DEM@PERMANENT slope=slope

# export
# r.out.gdal input=DEM@PERMANENT output=C:\RA\Zoning\Raleigh_Prototype_Zoning\DEM\DEM.tif format=GTiff
# r.out.gdal input=slope@PERMANENT output=C:\RA\Zoning\Raleigh_Prototype_Zoning\DEM\Slope.tif format=GTiff


# Join population data with census block groups
# done in R
# load in joined data
v.import --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\pop_block\pop_block.shp output=pop
v.to.rast --overwrite input=pop@PERMANENT type=area output=pop_rast@PERMANENT use=attr attribute_column=Totl_Pp label_column=Totl_Pp

# Population Density
# find area of polygons
v.to.db --overwrite map=pop@PERMANENT option=area columns=area units=meters query_column=Totl_Pp
# Create new column named pop_dens
    # open attribute table
    # > tab Manage tables > Add column > type = double
    # v.db.addcolumn
    # Tab Browse data > right click pop dens column > field calculator 
    # v.db.update
    # Find population per 100 square miles
    # query = UPDATE pop SET pop_dens =  Totl_Pp  /   (area  / 100)  
# vector to raster using pop dens field
v.to.rast --overwrite input=pop@PERMANENT type=area output=pop_dens use=attr attribute_column=pop_dens

# Calculate 
# Vector to raster

# Create binary layer - agricultue vs not 
r.reclass --overwrite input=agriculture@PERMANENT output=ag_reclass@PERMANENT rules=C:\RA\Zoning\crop_reclass.txt
r.category ag_reclass

# find distance to agriculture
r.grow.distance --overwrite input=ag_reclass@PERMANENT distance=dist_ag

# building height to raster
# building height SEPH attribute sum-elevations per hectare (from this the 6 categories are determined)
v.to.rast --overwrite input=building_ht@PERMANENT type=area output=building_ht_rast@PERMANENT use=attr attribute_column=SEPH label_column=Height_cat

## Individual Counties
# get full extent for Wake Region
g.region vector=Wake_County_Line@PERMANENT
v.in.region --overwrite output=wake_region
v.to.rast --overwrite input=wake_region@PERMANENT type=area output=wake_region_rast use=cat
g.region raster=wake_region_rast
# get areas inside of wake county
v.to.rast --overwrite input=Wake_County_Line@PERMANENT type=area output=wake_county use=cat

# get full extent for Randolph Region
g.region vector=randolph_zoning
v.in.region --overwrite output=randolph_region
v.to.rast --overwrite input=randolph_region@PERMANENT type=area output=randolph_region_rast use=cat
g.region raster=randolph_region_rast

# get full extent for Harnett Region
g.region vector=harnett_zoning
v.in.region --overwrite output=harnett_region
v.to.rast --overwrite input=harnett_region@PERMANENT type=area output=harnett_region_rast use=cat
g.region raster=harnett_region_rast

# Zoning data to raster
# export wake county zoning as raster
v.to.rast --overwrite input=wake_zoning@PERMANENT type=area output=wake_rast use=attr attribute_column=ZnID label_column=Zn_Dstr
# Harnett zoning to raster
v.to.rast --overwrite input=harnett_zoning@PERMANENT type=area output=harnett_rast use=attr attribute_column=ZoneID label_column=NwZnCls
# Randolph zoning to raster
v.to.rast --overwrite input=randolph_zoning@PERMANENT type=area output=randolph_rast use=attr attribute_column=ZoneID label_column=NwZnCls

# Export for each county extent
# See python file

# change vector boundary files for each county to raster
v.to.rast input=Harnett_boundary@PERMANENT type=area output=harnett_boundary_rast use=cat
r.out.gdal -c --overwrite input=nlcd_reclass@PERMANENT output=C:\RA\Zoning\Raleigh_Prototype_Zoning\analysis\test.tif format=GTiff
r.import input=C:\RA\Zoning\Raleigh_Prototype_Zoning\analysis\test.tif output=test --overwrite


#### After R & HPC
db.in.ogr --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\randolph_pred.csv output=randolph_xy

v.in.db --overwrite table=randolph_xy x=x y=y output=randolph_vec


r.in.xyz --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\harnett_predict_wake.csv output=harnett_predict_wake method=min separator=comma z=3 skip=1 value_column=4 type=CELL
r.in.xyz --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\harnett_predict_harnett.csv output=harnett_pred_rast method=min separator=comma z=3 skip=1 value_column=4 type=CELL
r.in.xyz --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\harnett_predict_randolph.csv output=harnett_predict_randolph method=min separator=comma z=3 skip=1 value_column=4 type=CELL
r.in.xyz --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\harnett_predict_all.csv output=harnett_predict_all method=min separator=comma z=3 skip=1 value_column=4 type=CELL

r.in.xyz --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\wake_predict_wake.csv output=wake_predict_wake method=min separator=comma z=3 skip=1 value_column=4 type=CELL
r.in.xyz --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\wake_predict_harnett.csv output=wake_predict_harnett method=min separator=comma z=3 skip=1 value_column=4 type=CELL
r.in.xyz --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\wake_predict_randolph.csv output=wake_predict_randolph method=min separator=comma z=3 skip=1 value_column=4 type=CELL
r.in.xyz --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\wake_predict_all.csv output=wake_predict_all method=min separator=comma z=3 skip=1 value_column=4 type=CELL

r.in.xyz --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\randolph_predict_wake.csv output=randolph_predict_wake method=min separator=comma z=3 skip=1 value_column=4 type=CELL
r.in.xyz --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\randolph_predict_harnett.csv output=randolph_predict_harnett method=min separator=comma z=3 skip=1 value_column=4 type=CELL
r.in.xyz --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\randolph_predict_randolph.csv output=randolph_predict_randolph method=min separator=comma z=3 skip=1 value_column=4 type=CELL
r.in.xyz --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\randolph_predict_all.csv output=randolph_predict_all method=min separator=comma z=3 skip=1 value_column=4 type=CELL

r.in.xyz --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\all_predict_wake.csv output=all_predict_wake method=min separator=comma z=3 skip=1 value_column=4 type=CELL
r.in.xyz --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\all_predict_harnett.csv output=all_predict_harnett method=min separator=comma z=3 skip=1 value_column=4 type=CELL
r.in.xyz --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\all_predict_randolph.csv output=all_predict_randolph method=min separator=comma z=3 skip=1 value_column=4 type=CELL
r.in.xyz --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\all_predict_all.csv output=all_predict_all method=min separator=comma z=3 skip=1 value_column=4 type=CELL