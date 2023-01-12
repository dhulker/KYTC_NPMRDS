-- SUBPART E - Level of Travel Time Reliability (LOTTR) § 490.507(a)

/*
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
*/
/* 
TT_Percentiles[offset(50)] as TT50th, -- 490.511 (b) (2)
TT_Percentiles[offset(80)] as TT80th, -- 490.511 (b) (2)
approx_quantiles(travel_time_minutes * 60, 100) as TT_Seconds_Percentiles,
approx_quantiles(speed, 100) as Speed_Mph_Percentiles
*/
Create table `kytc-planning.NPMRDS.INRIX_TMC_E_1` as 
-- The following query is for 490.511 (b) (1) (i) for years 2017+
/*      
(i) Includes travel times occurring between the hours of 6 a.m. and 10 a.m. 
for every weekday (Monday-Friday) from January 1st through December 31st of the 
same year;
*/
select
    tmc_code as INRIX_TMC1, -- TMC Identifier
    count(tmc_code) as TMC_ROW_COUNT,
    extract(DATE from measurement_tstamp) as inrix_date1, -- Date of Record (ex: 2018-02-01)
    extract(YEAR from measurement_tstamp) as inrix_year,
    floor((extract(HOUR from measurement_tstamp) 
        + extract(MINUTE from measurement_tstamp) 
        / 0.6 / 100) * 12 / 3) / 4 as TOD_value, -- This creates the 15 minute bins out of 5 minute records
    "LOTTR_AMP" as Reporting_Bin,
    "All_Vehicles" as Vehicle_Type,
    "6AM-10AM" as time_of_day_value,
    "MON-FRI" as weekdays_value,
    avg(speed) as Speed_Mph,
    avg(travel_time_minutes * 60) as Travel_time_seconds -- Travel time converted to seconds 
from
    `kytc-planning.Inrix_TMC_Data.inrix_tmc_2017_Present_all`
where
    travel_time_minutes is not null -- 490.509 (b)
    and (floor((extract(HOUR from measurement_tstamp) 
        + extract(MINUTE from measurement_tstamp) 
        / 0.6 / 100) * 12 / 3) / 4 > 5.75
        and floor((extract(HOUR from measurement_tstamp) 
        + extract(MINUTE from measurement_tstamp) 
        / 0.6 / 100) * 12 / 3) / 4 < 10)  -- 6AM to 10AM 
    and (extract(DAYOFWEEK from measurement_tstamp) > 1 and extract(DAYOFWEEK from measurement_tstamp) < 7) -- 1 = SUN while 7 = SAT (Weekdays only)
GROUP BY
    tmc_code,
    extract(DATE from measurement_tstamp),
    extract(YEAR from measurement_tstamp),
    floor((extract(HOUR from measurement_tstamp) 
        + extract(MINUTE from measurement_tstamp) 
        / 0.6 / 100) * 12 / 3) / 4
union all
-- The following query is for 490.511 (b) (1) (ii) for years 2017+
/* 
(ii) Includes travel times occurring between the hours of 10 a.m. and 4 p.m. 
for every weekday (Monday-Friday) from January 1st through December 31st of the 
same year
*/
select
    tmc_code as INRIX_TMC1, -- TMC Identifier
    count(tmc_code) as TMC_ROW_COUNT,
    extract(DATE from measurement_tstamp) as inrix_date1, -- Date of Record (ex: 2018-02-01)
    extract(YEAR from measurement_tstamp) as inrix_year,
    floor((extract(HOUR from measurement_tstamp) 
        + extract(MINUTE from measurement_tstamp) 
        / 0.6 / 100) * 12 / 3) / 4 as TOD_value, -- This creates the 15 minute bins out of 5 minute records
    "LOTTR_MIDD" as Reporting_Bin,
    "All_Vehicles" as Vehicle_Type,
    "10AM-4PM" as time_of_day_value,
    "MON-FRI" as weekdays_value,
    avg(speed) as Speed_Mph,
    avg(travel_time_minutes * 60) as Travel_time_seconds -- Travel time converted to seconds 
from
    `kytc-planning.Inrix_TMC_Data.inrix_tmc_2017_Present_all`
where
    travel_time_minutes is not null -- 490.509 (b)
    and (floor((extract(HOUR from measurement_tstamp) 
        + extract(MINUTE from measurement_tstamp) 
        / 0.6 / 100) * 12 / 3) / 4 > 9.75
        and floor((extract(HOUR from measurement_tstamp) 
        + extract(MINUTE from measurement_tstamp) 
        / 0.6 / 100) * 12 / 3) / 4 < 16)  -- 10AM to 4PM 
    and (extract(DAYOFWEEK from measurement_tstamp) > 1 
        and extract(DAYOFWEEK from measurement_tstamp) < 7) -- 1 = SUN while 7 = SAT (Weekdays only)
GROUP BY
    tmc_code,
    extract(DATE from measurement_tstamp),
    extract(YEAR from measurement_tstamp),
    floor((extract(HOUR from measurement_tstamp) 
        + extract(MINUTE from measurement_tstamp) 
        / 0.6 / 100) * 12 / 3) / 4
Union All

-- The following query is for 490.511 (b) (1) (iii) for years 2017+
/* 
(iii) Includes travel times occurring between the hours of 4 p.m. and 8 p.m. 
for every weekday (Monday-Friday) from January 1st through December 31st of the 
same year; and
*/
select
    tmc_code as INRIX_TMC1, -- TMC Identifier
    count(tmc_code) as TMC_ROW_COUNT,
    extract(DATE from measurement_tstamp) as inrix_date1, -- Date of Record (ex: 2018-02-01)
    extract(YEAR from measurement_tstamp) as inrix_year,
    floor((extract(HOUR from measurement_tstamp) 
        + extract(MINUTE from measurement_tstamp) 
        / 0.6 / 100) * 12 / 3) / 4 as TOD_value, -- This creates the 15 minute bins out of 5 minute records
    "LOTTR_PMP" as Reporting_Bin,
    "All_Vehicles" as Vehicle_Type,
    "4PM-8PM" as time_of_day_value,
    "MON-FRI" as weekdays_value,
    avg(speed) as Speed_Mph,
    avg(travel_time_minutes * 60) as Travel_time_seconds -- Travel time converted to seconds 
from
    `kytc-planning.Inrix_TMC_Data.inrix_tmc_2017_Present_all`
where
    travel_time_minutes is not null -- 490.509 (b)
    and (floor((extract(HOUR from measurement_tstamp) 
        + extract(MINUTE from measurement_tstamp) 
        / 0.6 / 100) * 12 / 3) / 4 > 15.75 
        and floor((extract(HOUR from measurement_tstamp) 
        + extract(MINUTE from measurement_tstamp) 
        / 0.6 / 100) * 12 / 3) / 4 < 20)  -- 10AM to 4PM 
    and (extract(DAYOFWEEK from measurement_tstamp) > 1 
        and extract(DAYOFWEEK from measurement_tstamp) < 7) -- 1 = SUN while 7 = SAT (Weekdays only)
GROUP BY
    tmc_code,
    extract(DATE from measurement_tstamp),
    extract(YEAR from measurement_tstamp),
    floor((extract(HOUR from measurement_tstamp) 
        + extract(MINUTE from measurement_tstamp) 
        / 0.6 / 100) * 12 / 3) / 4
Union All
-- The following query is for 490.511 (b) (1) (iv) for years 2017+
/* 
(iv) Includes travel times occurring between the hours of 6: a.m. and 8: p.m. 
for every weekend day (Saturday-Sunday) from January 1st through December 31st 
of the same year.
*/
select
    tmc_code as INRIX_TMC1, -- TMC Identifier
    count(tmc_code) as TMC_ROW_COUNT,
    extract(DATE from measurement_tstamp) as inrix_date1, -- Date of Record (ex: 2018-02-01)
    extract(YEAR from measurement_tstamp) as inrix_year,
    floor((extract(HOUR from measurement_tstamp) 
        + extract(MINUTE from measurement_tstamp) 
        / 0.6 / 100) * 12 / 3) / 4 as TOD_value, -- This creates the 15 minute bins out of 5 minute records
    "LOTTR_WE" as Reporting_Bin,
    "All_Vehicles" as Vehicle_Type,
    "6AM-8PM" as time_of_day_value,
    "SAT-SUN" as weekdays_value,
    avg(speed) as Speed_Mph,
    avg(travel_time_minutes * 60) as Travel_time_seconds -- Travel time converted to seconds 
from
    `kytc-planning.Inrix_TMC_Data.inrix_tmc_2017_Present_all`
where
    travel_time_minutes is not null -- 490.509 (b)
    and (floor((extract(HOUR from measurement_tstamp) 
        + extract(MINUTE from measurement_tstamp) 
        / 0.6 / 100) * 12 / 3) / 4 > 5.75 
        and floor((extract(HOUR from measurement_tstamp) 
        + extract(MINUTE from measurement_tstamp) 
        / 0.6 / 100) * 12 / 3) / 4 < 20)  -- 10AM to 4PM 
    and (extract(DAYOFWEEK from measurement_tstamp) = 1 
        or extract(DAYOFWEEK from measurement_tstamp) = 7) -- 1 = SUN while 7 = SAT (Weekends only)
GROUP BY
    tmc_code,
    extract(DATE from measurement_tstamp),
    extract(YEAR from measurement_tstamp),
    floor((extract(HOUR from measurement_tstamp) 
        + extract(MINUTE from measurement_tstamp) 
        / 0.6 / 100) * 12 / 3) / 4
Union All
-- The following query is for 490.511 (b) (1) (i) for years 2011-2016
/*      
(i) Includes travel times occurring between the hours of 6 a.m. and 10 a.m. 
for every weekday (Monday-Friday) from January 1st through December 31st of the 
same year;
*/
select
    tmc_code as INRIX_TMC1, -- TMC Identifier
    count(tmc_code) as TMC_ROW_COUNT,
    extract(DATE from measurement_tstamp) as inrix_date1, -- Date of Record (ex: 2018-02-01)
    extract(YEAR from measurement_tstamp) as inrix_year,
    floor((extract(HOUR from measurement_tstamp) 
        + extract(MINUTE from measurement_tstamp) 
        / 0.6 / 100) * 12 / 3) / 4 as TOD_value, -- This creates the 15 minute bins out of 5 minute records
    "LOTTR_AMP" as Reporting_Bin,
    "All_Vehicles" as Vehicle_Type,
    "6AM-10AM" as time_of_day_value,
    "MON-FRI" as weekdays_value,
    avg(speed) as Speed_Mph,
    avg(travel_time_minutes * 60) as Travel_time_seconds -- Travel time converted to seconds 
from
    `kytc-planning.Inrix_TMC_Data.inrix_tmc_2011_2016_all`
where
    travel_time_minutes is not null -- 490.509 (b)
    and (floor((extract(HOUR from measurement_tstamp) 
        + extract(MINUTE from measurement_tstamp) 
        / 0.6 / 100) * 12 / 3) / 4 > 5.75 
        and floor((extract(HOUR from measurement_tstamp) 
        + extract(MINUTE from measurement_tstamp) 
        / 0.6 / 100) * 12 / 3) / 4 < 10)  -- 6AM to 10AM 
    and (extract(DAYOFWEEK from measurement_tstamp) > 1 
        and extract(DAYOFWEEK from measurement_tstamp) < 7) -- 1 = SUN while 7 = SAT (Weekdays only)
GROUP BY
    tmc_code,
    extract(DATE from measurement_tstamp),
    extract(YEAR from measurement_tstamp),
    floor((extract(HOUR from measurement_tstamp) 
        + extract(MINUTE from measurement_tstamp) 
        / 0.6 / 100) * 12 / 3) / 4
union all
-- The following query is for 490.511 (b) (1) (ii) for years 2011-2016
/* 
(ii) Includes travel times occurring between the hours of 10 a.m. and 4 p.m. 
for every weekday (Monday-Friday) from January 1st through December 31st of the 
same year
*/
select
    tmc_code as INRIX_TMC1, -- TMC Identifier
    count(tmc_code) as TMC_ROW_COUNT,
    extract(DATE from measurement_tstamp) as inrix_date1, -- Date of Record (ex: 2018-02-01)
    extract(YEAR from measurement_tstamp) as inrix_year,
    floor((extract(HOUR from measurement_tstamp) 
        + extract(MINUTE from measurement_tstamp) 
        / 0.6 / 100) * 12 / 3) / 4 as TOD_value, -- This creates the 15 minute bins out of 5 minute records
    "LOTTR_MIDD" as Reporting_Bin,
    "All_Vehicles" as Vehicle_Type,
    "10AM-4PM" as time_of_day_value,
    "MON-FRI" as weekdays_value,
    avg(speed) as Speed_Mph,
    avg(travel_time_minutes * 60) as Travel_time_seconds -- Travel time converted to seconds 
from
    `kytc-planning.Inrix_TMC_Data.inrix_tmc_2011_2016_all`
where
    travel_time_minutes is not null -- 490.509 (b)
    and (floor((extract(HOUR from measurement_tstamp) 
        + extract(MINUTE from measurement_tstamp) 
        / 0.6 / 100) * 12 / 3) / 4 > 9.75 
        and floor((extract(HOUR from measurement_tstamp) 
        + extract(MINUTE from measurement_tstamp) 
        / 0.6 / 100) * 12 / 3) / 4 < 16)  -- 10AM to 4PM 
    and (extract(DAYOFWEEK from measurement_tstamp) > 1 
        and extract(DAYOFWEEK from measurement_tstamp) < 7) -- 1 = SUN while 7 = SAT (Weekdays only)
GROUP BY
    tmc_code,
    extract(DATE from measurement_tstamp),
    extract(YEAR from measurement_tstamp),
    floor((extract(HOUR from measurement_tstamp) 
        + extract(MINUTE from measurement_tstamp) 
        / 0.6 / 100) * 12 / 3) / 4
Union All
-- The following query is for 490.511 (b) (1) (iii) for years 2011-2016
/* 
(iii) Includes travel times occurring between the hours of 4 p.m. and 8 p.m. 
for every weekday (Monday-Friday) from January 1st through December 31st of the 
same year; and
*/
select
    tmc_code as INRIX_TMC1, -- TMC Identifier
    count(tmc_code) as TMC_ROW_COUNT,
    extract(DATE from measurement_tstamp) as inrix_date1, -- Date of Record (ex: 2018-02-01)
    extract(YEAR from measurement_tstamp) as inrix_year,
    floor((extract(HOUR from measurement_tstamp) 
        + extract(MINUTE from measurement_tstamp) 
        / 0.6 / 100) * 12 / 3) / 4 as TOD_value, -- This creates the 15 minute bins out of 5 minute records
    "LOTTR_PMP" as Reporting_Bin,
    "All_Vehicles" as Vehicle_Type,
    "4PM-8PM" as time_of_day_value,
    "MON-FRI" as weekdays_value,
    avg(speed) as Speed_Mph,
    avg(travel_time_minutes * 60) as Travel_time_seconds -- Travel time converted to seconds 
from
    `kytc-planning.Inrix_TMC_Data.inrix_tmc_2011_2016_all`
where
    travel_time_minutes is not null -- 490.509 (b)
    and (floor((extract(HOUR from measurement_tstamp) 
        + extract(MINUTE from measurement_tstamp) 
        / 0.6 / 100) * 12 / 3) / 4 > 15.75 
        and floor((extract(HOUR from measurement_tstamp) 
        + extract(MINUTE from measurement_tstamp) 
        / 0.6 / 100) * 12 / 3) / 4 < 20)  -- 10AM to 4PM 
    and (extract(DAYOFWEEK from measurement_tstamp) > 1 
        and extract(DAYOFWEEK from measurement_tstamp) < 7) -- 1 = SUN while 7 = SAT (Weekdays only)
GROUP BY
    tmc_code,
    extract(DATE from measurement_tstamp),
    extract(YEAR from measurement_tstamp),
    floor((extract(HOUR from measurement_tstamp) 
        + extract(MINUTE from measurement_tstamp) 
        / 0.6 / 100) * 12 / 3) / 4
Union All
-- The following query is for 490.511 (b) (1) (iv) for years 2011-2016
/* 
(iv) Includes travel times occurring between the hours of 6: a.m. and 8: p.m. 
for every weekend day (Saturday-Sunday) from January 1st through December 31st 
of the same year.
*/
select
    tmc_code as INRIX_TMC1, -- TMC Identifier
    count(tmc_code) as TMC_ROW_COUNT,
    extract(DATE from measurement_tstamp) as inrix_date1, -- Date of Record (ex: 2018-02-01)
    extract(YEAR from measurement_tstamp) as inrix_year,
    floor((extract(HOUR from measurement_tstamp) 
        + extract(MINUTE from measurement_tstamp) 
        / 0.6 / 100) * 12 / 3) / 4 as TOD_value, -- This creates the 15 minute bins out of 5 minute records
    "LOTTR_WE" as Reporting_Bin,
    "All_Vehicles" as Vehicle_Type,
    "6AM-8PM" as time_of_day_value,
    "SAT-SUN" as weekdays_value,
    avg(speed) as Speed_Mph,
    avg(travel_time_minutes * 60) as Travel_time_seconds -- Travel time converted to seconds 
from
    `kytc-planning.Inrix_TMC_Data.inrix_tmc_2011_2016_all`
where
    travel_time_minutes is not null -- 490.509 (b)
    and (floor((extract(HOUR from measurement_tstamp) 
        + extract(MINUTE from measurement_tstamp) 
        / 0.6 / 100) * 12 / 3) / 4 > 5.75 
        and floor((extract(HOUR from measurement_tstamp) 
        + extract(MINUTE from measurement_tstamp) 
        / 0.6 / 100) * 12 / 3) / 4 < 20)  -- 10AM to 4PM 
    and (extract(DAYOFWEEK from measurement_tstamp) = 1 
        or extract(DAYOFWEEK from measurement_tstamp) = 7) -- 1 = SUN while 7 = SAT (Weekends only)
GROUP BY
    tmc_code,
    extract(DATE from measurement_tstamp),
    extract(YEAR from measurement_tstamp),
    floor((extract(HOUR from measurement_tstamp) 
        + extract(MINUTE from measurement_tstamp) 
        / 0.6 / 100) * 12 / 3) / 4