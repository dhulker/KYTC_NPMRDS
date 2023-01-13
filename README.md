# NPMRDS SQL Queries for Calculating Subparts E and F for PM3 Reporting Requirements

This Repository contains a series of SQL codes and table schema that are used to calculate NPMRDS PM3 subparts E and F. This is a pure SQL implementation for those who are tasked with managing PM3 data.  Each query for each subpart will create a table that is referenced by the subsequent queries.  The data stored in each of these tables is 5-minute increment data that the queries will average to create 15-minute bins.  This allows one to store the least aggregated data available while also still being able to calculate PM3 measures.  There are some anomalies when compared to what RITIS will give you with the "easy Button", but the values between the two calculations are usually very close if not exactly the same. 


# Overview 
State Transportation agencies and Metropolitan Planning Organizations are required to set targets for performance based upon information contained within the National Performance Management Research Data Set.  The NPMRDS is (as of 2023) available from the [RITIS website](https://npmrds.ritis.org/) for download.  Additionally, State agencies must submit a report of the NPMRDS as part of its Highway Performance Management System (HPMS) submission annually.  

## Setup
The Kentucky Transportation Cabinet currently uses Google Cloud's BigQuery to manage all data downloaded from the NPMRDS.  The data is stored in a series of tables that are created and updated directly from csv files produced by RITIS.  People using different SQL implementations may have trouble running some queries and may have to rewrite some parts to get them to work effectively.  

## Downloading the data
To download NPMRDS data, go to the [Massive Data Downloader](https://npmrds.ritis.org/analytics/download/) and make sure that the following options are selected:
	1. Select TMC Segments from the appropriate provider and year
	    a. Select Kentucky as the Region
	2. Select the date range (Typically one month at a time)
	3. Make sure that all days of the week are selected.
	4. Make sure that all times of day are selected.
	5. Select ONLY the applicable vehicle type
		a. Select the following fields: Speed, Historic average speed, Reference speed, Travel time, and Data Density
	6. Select Minutes for travel time.
	7. Include Null Values
	8. Select "Don't Average"
	9. Name the download "NPMRDS_[Year]_[Month]_[Vehicle Type]_WithNulls"
	10. Get Notified by Email.
	    a. Click Submit
	    b. Go back to (5) and change the vehicle type
	    c. Change the name in (9) to reflect the new vehicle type
	    d. Click submit for the new file
	    e. Repeat (c) through (e) for the final vehicle type
	    f. Go to https://npmrds.ritis.org/analytics/my-history/ and download files once they are ready.

Once all that is complete, you will need to extract the csv files and upload to your database.  IF you are using BigQuery, then the queries should work if the tables are set up in the same manner.  For table schema, see the json files in the table_schema directory.

## Tables used
The following tables are used:
    `kytc-planning.Inrix_TMC_Metadata.INRIX_TMC_Metadata`
    `kytc-planning.Inrix_TMC_Data.inrix_tmc_2011_2016_all`
    `kytc-planning.Inrix_TMC_Data.inrix_tmc_2017_Present_all`
    `kytc-planning.Inrix_TMC_Data.inrix_tmc_2011_2016_trucks`
    `kytc-planning.Inrix_TMC_Data.inrix_tmc_2017_Present_trucks`

## How to Run Each Query
Each query is meant to be run in sequence.  Tables not listed above are created by queries and usually referenced by later queries.


## Subpart E - Level of Overall Travel Time Reliability

### Regulations
23 CFR § 490.511 - Calculation of National Highway System performance metrics.
§ 490.511 Calculation of National Highway System performance metrics.
(a) Two performance metrics are required for the NHS Performance measures 
specified in § 490.507. These are:
    (1) Level of Travel Time Reliability (LOTTR) for the Travel Time Reliability 
    measures in § 490.507(a) (referred to as the LOTTR metric).
    (2) [Reserved]
(b) The State DOT shall calculate the LOTTR metrics for each NHS reporting segment in 
accordance with the following:
    (1) Data sets shall be created from the travel time data set to be used to 
    calculate the LOTTR metrics. This data set shall include, for each reporting segment, 
    a ranked list of average travel times for all traffic (“all vehicles” in NPMRDS 
    nomenclature), to the nearest second, for 15 minute periods of a population that:
        (i) [See Query];
        (ii) [See Query];
        (iii) [See Query];
        (iv) [See Query];

### Queries

#### Subpart_E_1.sql
This query uses the 5-minute data from INRIX's TMC set and creates 15-minute rows of average travel time, converts it from minutes to seconds, and creates a series of times that correspond to PM3 reporting requirements for subpart E.

### Subpart_E_2.sql
The second query returns quantiles and percentage values for travel time and speeds for each TMC/reporting time.

### Subpart_E_3.sql
The third query selects the 80th and 50th percentile speed and travel times.

### Subpart_E_4.sql
This query calculates the level of travel time reliability for each reporting time for Subpart E.  These are the values that normally go into the annual HPMS report under the LOTTR_ fields.

### Subpart_E_5.sql
This query finds the maximum value for the level of travel time reliability.

### Subpart_E_6.sql
This query joins the results from the last query to a custom metadata table that was created from the following sources:
    1. RITIS provided metadata from the "Easy Button"
    2. NPMRDS metadata from the shapefile for each year
    3. KYTC generated data from tagging the NPMRDS shapefile with KYTC's data using it's Highway Information System (HIS)

Also, Annual Volume-miles are calculated at this step, both the total and the total mileage below a LOTTR of 1.5 for each TMC

### Subpart_E_6.sql
The final query calculates the level of travel time reliability for all TMCs in a group.  In the example given, it is calculating the Subpart E measure for an MPO planning area but it is very easy to comment/uncomment other lines to calculate it for other areas.


## Subpart F - Truck Travel Time Reliability
