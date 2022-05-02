
# region of interest
v.import --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\county_boundary\Example_Counties.shp layer=Example_Counties output=Example_Counties

# set region
g.region raster=Example_Counties_rast

# import block group layer
v.import --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\census_block_group\tl_2010_37_bg10.shp layer=tl_2010_37_bg10 output=bg_2010
v.import --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\census_block_group\tl_2013_37_bg.shp layer=tl_2013_37_bg output=bg_2013
v.import --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\census_block_group\tl_2014_37_bg.shp layer=tl_2014_37_bg output=bg_2014
v.import --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\census_block_group\tl_2015_37_bg.shp layer=tl_2015_37_bg output=bg_2015
v.import --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\census_block_group\tl_2016_37_bg.shp layer=tl_2016_37_bg output=bg_2016
v.import --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\census_block_group\tl_2017_37_bg.shp layer=tl_2017_37_bg output=bg_2017
v.import --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\census_block_group\tl_2018_37_bg.shp layer=tl_2018_37_bg output=bg_2018
v.import --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\census_block_group\tl_2019_37_bg.shp layer=tl_2019_37_bg output=bg_2019

# Household Size as table
# v.import --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\housing_size_sp\housing_size_sp.shp output=household_size
db.in.ogr --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\Household_size\2010_household_bg.csv output=hhld_size_2010
db.in.ogr --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\Household_size\2013_household_bg.csv output=hhld_size_2013
db.in.ogr --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\Household_size\2014_household_bg.csv output=hhld_size_2014
db.in.ogr --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\Household_size\2015_household_bg.csv output=hhld_size_2015
db.in.ogr --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\Household_size\2016_household_bg.csv output=hhld_size_2016
db.in.ogr --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\Household_size\2017_household_bg.csv output=hhld_size_2017
db.in.ogr --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\Household_size\2018_household_bg.csv output=hhld_size_2018
db.in.ogr --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\Household_size\2019_household_bg.csv output=hhld_size_2019

# v.db.addcolumn map=bg_2010@PERMANENT columns="GEOID_US character"
# v.db.update map=bg_2010@PERMANENT column=GEOID_US query_column="1500000US" + GEOID10

# Join household size attribute from table to block group layer
v.db.join map=bg_2010@PERMANENT column=GEOID10 other_table=hhld_size_2010 other_column=GEO_ID

# table with dwelling units per zone
db.in.ogr --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\Res_desc.csv output=res_desc

# Predicted zones as points
v.import --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\wake_points\wake_points.shp output=wake_points
v.import --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\harnett_points\harnett_points.shp output=harnett_points
v.import --overwrite input=C:\RA\Zoning\Raleigh_Prototype_Zoning\randolph_points\randolph_points.shp output=randolph_points

# fix type of du_pixel
v.db.update harnett_points col=du_pixel qcol="CAST(du_pixel AS double precision)" where="du_pixel <> 'N/A'"
v.db.update randolph_points col=du_pixel qcol="CAST(du_pixel AS double precision)" where="du_pixel <> 'N/A'"

## python
# overlay
v.db.addcolumn map=wake_points@PERMANENT columns="hsng_sz double precision"
v.db.addcolumn map=harnett_points@PERMANENT columns="hsng_sz double precision"
v.db.addcolumn map=randolph_points@PERMANENT columns="hsng_sz double precision"

v.what.vect map=wake_points@PERMANENT column=hsng_sz query_map=household_size@PERMANENT query_column=hsng_sz
v.what.vect map=harnett_points@PERMANENT column=hsng_sz query_map=household_size@PERMANENT query_column=hsng_sz
v.what.vect map=randolph_points@PERMANENT column=hsng_sz query_map=household_size@PERMANENT query_column=hsng_sz

v.db.addcolumn map=wake_points@PERMANENT columns="pop_dens double precision"
v.db.addcolumn map=harnett_points@PERMANENT columns="pop_dens double precision"
v.db.addcolumn map=randolph_points@PERMANENT columns="pop_dens double precision"

# Join dwelling unit info to point data
v.db.join map=wake_points@PERMANENT column=predict other_table=res_desc other_column=ZnID
v.db.join map=harnett_points@PERMANENT column=predict other_table=res_desc other_column=ZnID
v.db.join map=randolph_points@PERMANENT column=predict other_table=res_desc other_column=ZnID



#find pop dens
v.db.update map=wake_points@PERMANENT column=pop_dens query_column=du_pixel*hsng_sz
v.db.update map=harnett_points@PERMANENT column=pop_dens query_column=du_pixel*hsng_sz
v.db.update map=randolph_points@PERMANENT column=pop_dens query_column=du_pixel*hsng_sz

v.out.ogr -s -e --overwrite input=wake_points@PERMANENT type=point output=C:\RA\Zoning\Raleigh_Prototype_Zoning\wake_size format=ESRI_Shapefile
v.out.ogr -s -e --overwrite input=harnett_points@PERMANENT type=point output=C:\RA\Zoning\Raleigh_Prototype_Zoning\harnett_size format=ESRI_Shapefile
v.out.ogr -s -e --overwrite input=randolph_points@PERMANENT type=point output=C:\RA\Zoning\Raleigh_Prototype_Zoning\randolph_size format=ESRI_Shapefile

# export attribute table
v.db.select --overwrite map=wake_points@PERMANENT format=plain file=C:\RA\Zoning\Raleigh_Prototype_Zoning\Res_desc.csv