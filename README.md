# NPMRDS SQL Queries for Calculating Subparts E and F for PM3 Reporting Requirements

This Repository contains a series of SQL codes and table schema that are used to calculate NPMRDS PM3 subparts E and F. This is a pure SQL implementation for those who are tasked with managing PM3 data.  Each query for each subpart will create a table that is referenced by the subsequent queries.  The data stored in each of these tables is 5-minute increment data that the queries will average to create 15-minute bins.  This allows one to store the least aggregated data available while also still being able to calculate PM3 measures.  There are some anomalies when compared to what RITIS will give you with the "easy Button", but the values between the two calculations are usually very close if not exactly the same. 

# Overview 

State Transportation agencies and Metropolitan Planning Organizations are required to set targets for performance based upon information contained within the National Performance Management Research Data Set.  The NPMRDS is (as of 2023) available from the [RITIS website](https://npmrds.ritis.org/) for download.  Additionally, State agencies must submit a report of the NPMRDS as part of its Highway Performance Management System (HPMS) submission annually.  

## Setup

The Kentucky Transportation Cabinet currently uses Google Cloud's BigQuery to manage all data downloaded from the NPMRDS.  The data is stored in a series of tables that are created and updated directly from csv files produced by RITIS.  People using different SQL implementations may have trouble running some queries and may have to rewrite some parts to get them to work effectively.  

## Downloading the data

To download NPMRDS data, go to the [Massive Data Downloader](https://npmrds.ritis.org/analytics/download/) and make sure that the following options are selected:<br>
 &nbsp;&nbsp;1. Select TMC Segments from the appropriate provider and year <br>
&nbsp;&nbsp;&nbsp;&nbsp;1. Select Kentucky as the Region<br>
&nbsp;&nbsp;2. Select the date range (Typically one month at a time)<br>
&nbsp;&nbsp;3. Make sure that all days of the week are selected.<br>
&nbsp;&nbsp;4. Make sure that all times of day are selected.<br>
&nbsp;&nbsp;5. Select ONLY the applicable vehicle type<br>
&nbsp;&nbsp;&nbsp;&nbsp;1. Select the following fields: Speed, Historic average speed, Reference speed, Travel time, and Data Density<br>
&nbsp;&nbsp;6. Select Minutes for travel time.<br>
&nbsp;&nbsp;7. Include Null Values<br>
&nbsp;&nbsp;8. Select "Don't Average"<br>
&nbsp;&nbsp;9. Name the download "NPMRDS_[Year]_[Month]_[Vehicle Type]_WithNulls"<br>
&nbsp;&nbsp;10. Get Notified by Email.<br>
&nbsp;&nbsp;&nbsp;&nbsp;1. Click Submit<br>
&nbsp;&nbsp;&nbsp;&nbsp;2. Go back to (5) and change the vehicle type<br>
&nbsp;&nbsp;&nbsp;&nbsp;3. Change the name in (9) to reflect the new vehicle type<br>
&nbsp;&nbsp;&nbsp;&nbsp;4. Click submit for the new file<br>
&nbsp;&nbsp;&nbsp;&nbsp;5. Repeat (10)(2) through (10)(4) for the final vehicle type<br>
&nbsp;&nbsp;&nbsp;&nbsp;6. Go to https://npmrds.ritis.org/analytics/my-history/ and download files once they are ready.<br>

Once all that is complete, you will need to extract the csv files and upload to your database.  IF you are using BigQuery, then the queries should work if the tables are set up in the same manner.  For table schema, see the json files in the table_schema directory.

## Tables used

The following tables are used:<br>
&nbsp;&nbsp;`kytc-planning.Inrix_TMC_Metadata.INRIX_TMC_Metadata`<br>
&nbsp;&nbsp;`kytc-planning.Inrix_TMC_Data.inrix_tmc_2011_2016_all`<br>
&nbsp;&nbsp;`kytc-planning.Inrix_TMC_Data.inrix_tmc_2017_Present_all`<br>
&nbsp;&nbsp;`kytc-planning.Inrix_TMC_Data.inrix_tmc_2011_2016_trucks`<br>
&nbsp;&nbsp;`kytc-planning.Inrix_TMC_Data.inrix_tmc_2017_Present_trucks`<br>

## How to Run Each Query

Each query is meant to be run in sequence.  Tables not listed above are created by queries and usually referenced by later queries.


## Subpart E - Level of Overall Travel Time Reliability

§ 490.511 Calculation of National Highway System performance metrics.<br>
 &nbsp;&nbsp;(a) Two performance metrics are required for the NHS Performance measures specified in § 490.507. These are:<br>
 &nbsp;&nbsp;&nbsp;&nbsp;(1) Level of Travel Time Reliability (LOTTR) for the Travel Time Reliability measures in § 490.507(a) (referred to as the LOTTR metric).<br>
&nbsp;&nbsp;&nbsp;&nbsp;(2) [Reserved]<br>
 &nbsp;&nbsp;(b) The State DOT shall calculate the LOTTR metrics for each NHS reporting segment in accordance with the following:
&nbsp;&nbsp;&nbsp;&nbsp;(1) Data sets shall be created from the travel time data set to be used to calculate the LOTTR metrics. This data set shall include, for each reporting segment, a ranked list of average travel times for all traffic (“all vehicles” in NPMRDS nomenclature), to the nearest second, for 15 minute periods of a population that:
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(i) Includes travel times occurring between the hours of 6 a.m. and 10 a.m. for every weekday (Monday-Friday) from January 1st through December 31st of the same year;
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(ii) Includes travel times occurring between the hours of 10 a.m. and 4 p.m. for every weekday (Monday-Friday) from January 1st through December 31st of the same year;
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(iii) Includes travel times occurring between the hours of 4 p.m. and 8 p.m. for every weekday (Monday-Friday) from January 1st through December 31st of the same year; and
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(iv) Includes travel times occurring between the hours of 6: a.m. and 8: p.m. for every weekend day (Saturday-Sunday) from January 1st through December 31st of the same year.
 &nbsp;&nbsp;&nbsp;&nbsp;(2) The Normal Travel Time (50th percentile) shall be determined from each data set defined under paragraph (b)(1) of this section as the time in which 50 percent of the times in the data set are shorter in duration and 50 percent are longer in duration. The 80th percentile travel time shall be determined for each data set defined under paragraph (b)(1) of this section as the time in which 80 percent of the times in the data set are shorter in duration and 20 percent are longer in duration. Both the Normal and 80th percentile travel times can be determined by plotting the data on a travel time cumulative probability distribution graph or using the percentile functions available in spreadsheet and other analytical tools.
 &nbsp;&nbsp;&nbsp;&nbsp;(3) Four LOTTR metrics shall be calculated for each reporting segment; one for each data set defined under paragraph (b)(1) of this section as the 80th percentile travel time divided by the 50th percentile travel time and rounded to the nearest hundredth.
 &nbsp;&nbsp;(c)-(d) [Reserved]
 &nbsp;&nbsp;(e) Starting in 2018 and annually thereafter, State DOTs shall report the LOTTR metrics, defined in paragraph (b) of this section, in accordance with HPMS Field Manual by June 15th of each year for the previous year's measures.
 &nbsp;&nbsp;&nbsp;&nbsp;(1) Metrics are reported to HPMS by reporting segment. All reporting segments where the NPMRDS is used shall be referenced by NPMRDS TMC(s) or HPMS section(s). If a State DOT elects to use, in part or in whole, the equivalent data set, all reporting segment shall be referenced by HPMS section(s); and
 &nbsp;&nbsp;&nbsp;&nbsp;(2) The LOTTR metric (to the nearest hundredths) for each of the four time periods identified in paragraphs (b)(1)(i) through (iv) of this section: the corresponding 80th percentile travel times (to the nearest second), the corresponding Normal (50th percentile) Travel Times (to the nearest second), and directional AADTs. If a State DOT does not elect to use FHWA supplied occupancy factor, as provided in § 490.507(d), that State DOT shall report vehicle occupancy factor (to the nearest tenth) to HPMS.
 &nbsp;&nbsp;(f) [Reserved]
[82 FR 6031, Jan. 18, 2017, as amended at 83 FR 24936, May 31, 2018]

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

This query joins the results from the last query to a custom metadata table that was created from the following sources:<br>
&nbsp;&nbsp;1. RITIS provided metadata from the "Easy Button"<br>
&nbsp;&nbsp;2. NPMRDS metadata from the shapefile for each year<br>
&nbsp;&nbsp;3. KYTC generated data from tagging the NPMRDS shapefile with KYTC's data using it's Highway Information System (HIS)<br>

Also, Annual Volume-miles are calculated at this step, both the total and the total mileage below a LOTTR of 1.5 for each TMC

### Subpart_E_6.sql

The final query calculates the level of travel time reliability for all TMCs in a group.  In the example given, it is calculating the Subpart E measure for an MPO planning area but it is very easy to comment/uncomment other lines to calculate it for other areas.


## Subpart F - Truck Travel Time Reliability
