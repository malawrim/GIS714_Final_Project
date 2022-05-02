#!/usr/bin/env python3

import grass.script as gs
import glob


def main():
    # path = "C://RA//Zoning//Raleigh_Prototype_Zoning//Household_size"
    all_files = [
        "C:\\RA\\Zoning\\Raleigh_Prototype_Zoning\\Household_size\\2010_household_bg.csv",
        "C:\\RA\\Zoning\\Raleigh_Prototype_Zoning\\Household_size\\2013_household_bg.csv",
        "C:\\RA\\Zoning\\Raleigh_Prototype_Zoning\\Household_size\\2014_household_bg.csv",
        "C:\\RA\\Zoning\\Raleigh_Prototype_Zoning\\Household_size\\2015_household_bg.csv",
        "C:\\RA\\Zoning\\Raleigh_Prototype_Zoning\\Household_size\\2016_household_bg.csv",
        "C:\\RA\\Zoning\\Raleigh_Prototype_Zoning\\Household_size\\2017_household_bg_sz.csv",
        "C:\\RA\\Zoning\\Raleigh_Prototype_Zoning\\Household_size\\2018_household_bg_sz.csv",
        "C:\\RA\\Zoning\\Raleigh_Prototype_Zoning\\Household_size\\2019_household_bg.csv",
        "C:\\RA\\Zoning\\Raleigh_Prototype_Zoning\\Household_size\\2020_household_bg.csv",
    ]
    bg_layers = [
        "bg_2010@PERMANENT",
        "bg_2013@PERMANENT",
        "bg_2014@PERMANENT",
        "bg_2015@PERMANENT",
        "bg_2016@PERMANENT",
        "bg_2017@PERMANENT",
        "bg_2018@PERMANENT",
        "bg_2019@PERMANENT",
        "bg_2020@PERMANENT",
    ]
    output_files = [
        "household_bg_2010",
        "household_bg_2013",
        "household_bg_2014",
        "household_bg_2015",
        "household_bg_2016",
        "household_bg_2017",
        "household_bg_2018",
        "household_bg_2019",
        "household_bg_2020",
    ]
    hsg_years = [
        "2010",
        "2013",
        "2014",
        "2015",
        "2016",
        "2017",
        "2018",
        "2019",
        "2020",
    ]
    zones = [
        "wake_points@PERMANENT",
        "harnett_points@PERMANENT",
        "randolph_points@PERMANENT",
    ]

    for i in range(len(all_files)):
        # tmp = pd.read_csv(all_files[i])
        # tmp.replace("1500000US", "")
        # tmp.to_csv(all_files[i])
        gs.run_command(
            "db.in.ogr", overwrite=True, input=all_files[i], output=output_files[i]
        )
        gs.run_command(
            "v.db.join",
            map=bg_layers[i],
            column="GEOID",
            other_table=output_files[i],
            other_column="GEO_ID",
        )
        gs.run_command(
            "v.db.addcolumn", map=bg_layers[i], columns="h_sz double precision"
        )
        gs.run_command(
            "v.db.update", map=bg_layers[i], column="h_sz", query_column="hsng_sz"
        )
        ## Need to make h_sz double precisions ##
        for y in range(len(zones)):
            hs_col_name = "hs_" + hsg_years[i]
            gs.run_command(
                "v.db.addcolumn",
                map=zones[y],
                columns=hs_col_name + " double precision",
            )
            gs.run_command(
                "v.what.vect",
                map=zones[y],
                column=hs_col_name,
                query_map=bg_layers[i],
                query_column="h_sz",
            )
            pd_col_name = "pd_" + hsg_years[i]
            gs.run_command(
                "v.db.addcolumn",
                map=zones[y],
                columns=pd_col_name + " double precision",
            )
            gs.run_command(
                "v.db.join",
                map=zones[y],
                column="predict",
                other_table="res_desc",
                other_column="ZnID",
            )
            gs.run_command(
                "v.db.update",
                map=zones[y],
                column=pd_col_name,
                query_column="du_pixel*" + hs_col_name,
            )


def tract():
    # path = "C://RA//Zoning//Raleigh_Prototype_Zoning//Household_size"
    all_files = glob.glob(
        "C:\\RA\\Zoning\\Raleigh_Prototype_Zoning\\Household_size\\*_household_tract.csv"
    )
    bg_layers = ["tract_2011@PERMANENT", "tract_2012@PERMANENT"]
    output_files = ["household_tract_2011", "household_tract_2012"]
    hsg_years = ["2011", "2012"]
    zones = [
        "wake_points@PERMANENT",
        "harnett_points@PERMANENT",
        "randolph_points@PERMANENT",
    ]

    for i in range(len(all_files)):
        # tmp = pd.read_csv(all_files[i])
        # tmp.replace("1500000US", "")
        # tmp.to_csv(all_files[i])
        gs.run_command(
            "db.in.ogr", overwrite=True, input=all_files[i], output=output_files[i]
        )
        gs.run_command(
            "v.db.join",
            map=bg_layers[i],
            column="GEOID",
            other_table=output_files[i],
            other_column="GEO_ID",
        )
        gs.run_command(
            "v.db.addcolumn", map=bg_layers[i], columns="h_sz double precision"
        )
        gs.run_command(
            "v.db.update", map=bg_layers[i], column="h_sz", query_column="hsng_sz"
        )

        for y in range(len(zones)):
            hs_col_name = "hs_" + hsg_years[i]
            gs.run_command(
                "v.db.addcolumn",
                map=zones[y],
                columns=hs_col_name + " double precision",
            )
            gs.run_command(
                "v.what.vect",
                map=zones[y],
                column=hs_col_name,
                query_map=bg_layers[i],
                query_column="h_sz",
            )
            pd_col_name = "pd_" + hsg_years[i]
            gs.run_command(
                "v.db.addcolumn",
                map=zones[y],
                columns=pd_col_name + " double precision",
            )
            gs.run_command(
                "v.db.join",
                map=zones[y],
                column="predict",
                other_table="res_desc",
                other_column="ZnID",
            )
            gs.run_command(
                "v.db.update",
                map=zones[y],
                column=pd_col_name,
                query_column="du_pixel*" + hs_col_name,
            )

    # Display maps
    for y in range(len(zones)):
        gs.run_command("d.vect", map=zones[y])


def orginal_zone_test():
    zones = [
        "wake_points_new@PERMANENT",
        "harnett_points_new@PERMANENT",
        "randolph_points_new@PERMANENT",
    ]
    for y in range(len(zones)):
        hs_col_name = "hs_2010"
        gs.run_command(
            "v.db.addcolumn",
            map=zones[y],
            columns=hs_col_name + " double precision",
        )
        gs.run_command(
            "v.what.vect",
            map=zones[y],
            column=hs_col_name,
            query_map="bg_2010@PERMANENT",
            query_column="h_sz",
        )
        pd_col_name = "pd_2010"
        gs.run_command(
            "v.db.addcolumn",
            map=zones[y],
            columns=pd_col_name + " double precision",
        )
        gs.run_command(
            "v.db.join",
            map=zones[y],
            column="value",
            other_table="res_desc",
            other_column="ZnID",
        )
        gs.run_command(
            "v.db.update",
            map=zones[y],
            column=pd_col_name,
            query_column="du_pixel*" + hs_col_name,
        )


def bg_to_rast():
    bg_layers = [
        "bg_2010@PERMANENT",
        "bg_2013@PERMANENT",
        "bg_2014@PERMANENT",
        "bg_2015@PERMANENT",
        "bg_2016@PERMANENT",
        "bg_2017@PERMANENT",
        "bg_2018@PERMANENT",
        "bg_2019@PERMANENT",
        "bg_2020@PERMANENT",
    ]
    for i in range(len(bg_layers)):

        gs.run_command(
            "v.db.addcolumn", map=bg_layers[i], columns="geoid_num double precision"
        )
        gs.run_command(
            "v.db.update", map=bg_layers[i], column="geoid_num", query_column="GEO_ID"
        )
        gs.run_command(
            "v.to.rast",
            overwrite=True,
            input=bg_layers[i],
            type="area",
            use="attr",
            attribute_column="geoid_num",
            output=bg_layers[i],
        )


if __name__ == "__main__":
    main()
