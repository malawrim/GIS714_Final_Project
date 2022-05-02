#!/usr/bin/env python3

import grass.script as gs

# run bash script rural_counties_GRASS.sh
# or run gs.run_command('v.import', input='C:\RA\Zoning\Raleigh_Prototype_Zoning\Tigers_Road_State_2016\37\tl_2016_37_roads.shp' output='roads') for all files


def main():
    # list of files I want to export
    files = [
        "building_ht_rast@PERMANENT",
        "dist_ag@PERMANENT",
        "dist_census_place@PERMANENT",
        "dist_interstate@PERMANENT",
        "dist_metro_area@PERMANENT",
        "dist_protected@PERMANENT",
        "dist_road@PERMANENT",
        "nlcd_reclass@PERMANENT",
        "pop_dens@PERMANENT",
        "pop_rast@PERMANENT",
        "protected_rast@PERMANENT",
        "road_density@PERMANENT",
        "blg_density@PERMANENT",
        "dist_building@PERMANENT",
        "blg_area_rast@PERMANENT",
        "impervious@PERMANENT",
        "slope@PERMANENT",
        "dist_river@PERMANENT",
        "dist_lake@PERMANENT",
        "dist_interchange@PERMANENT",
    ]

    study_extent = [
        "wake_region_rast@PERMANENT",
        "randolph_region_rast@PERMANENT",
        "harnett_region_rast@PERMANENT",
    ]
    for x in study_extent:
        gs.run_command("g.region", raster=x)
        county = x.split("_")
        # export files
        for y in files:
            out = y.split("@")
            out = (
                "C:\\RA\\Zoning\\Raleigh_Prototype_Zoning\\analysis\\"
                + county[0]
                + "\\"
                + out[0]
                + ".tif"
            )
            gs.run_command(
                "r.out.gdal",
                overwrite=True,
                input=y,
                output=out,
                format="GTiff",
                flags="c",
            )
    gs.run_command("g.region", raster="harnett_region_rast@PERMANENT")
    gs.run_command(
        "r.out.gdal",
        overwrite=True,
        input="harnett_rast@PERMANENT",
        output="C:\\RA\\Zoning\\Raleigh_Prototype_Zoning\\analysis\\harnett\\harnett_rast.tif",
        format="GTiff",
        flags="c",
    )

    gs.run_command("g.region", raster="wake_region_rast@PERMANENT")
    gs.run_command(
        "r.out.gdal",
        overwrite=True,
        input="wake_rast@PERMANENT",
        output="C:\\RA\\Zoning\\Raleigh_Prototype_Zoning\\analysis\\wake\\wake_rast.tif",
        format="GTiff",
        flags="c",
    )
    # Also get wake county boundary
    gs.run_command(
        "r.out.gdal",
        overwrite=True,
        input="wake_county@PERMANENT",
        output="C:\\RA\\Zoning\\Raleigh_Prototype_Zoning\\analysis\\wake\\wake_county.tif",
        format="GTiff",
        flags="c",
    )

    gs.run_command("g.region", raster="randolph_region_rast@PERMANENT")
    gs.run_command(
        "r.out.gdal",
        overwrite=True,
        input="randolph_rast@PERMANENT",
        output="C:\\RA\\Zoning\\Raleigh_Prototype_Zoning\\analysis\\randolph\\randolph_rast.tif",
        format="GTiff",
        flags="c",
    )

    print("done")


def map():
    files = [
        "all_predict_all",
        "all_predict_harnett",
        "all_predict_randolph",
        "all_predict_wake",
        "harnett_predict_all",
        "harnett_predict_harnett",
        "harnett_predict_randolph",
        "harnett_predict_wake",
        "randolph_predict_all",
        "randolph_predict_harnett",
        "randolph_predict_randolph",
        "randolph_predict_wake",
        "wake_predict_all",
        "wake_predict_harnett",
        "wake_predict_randolph",
        "wake_predict_wake",
    ]

    for f in files:
        input = "C:\\RA\\Zoning\\Raleigh_Prototype_Zoning\\" + f + ".csv"
        output = f + "@PERMANENT"
        gs.run_command(
            "r.in.xyz",
            overwrite=True,
            input=input,
            output=output,
            method="min",
            separator="comma",
            z=3,
            skip=1,
            value_column=4,
            type="CELL",
        )
        gs.run_command(
            "r.colors",
            map=output,
            rules="C:\RA\Zoning\Raleigh_Prototype_Zoning\scripts\zone_color_rules.txt",
        )


if __name__ == "__main__":
    main()
