/*
Source: https://www.govinfo.gov/content/pkg/CFR-2020-title23-vol1/pdf/CFR-2020-title23-vol1-sec490-611.pdf
§ 490.611 Calculation of Truck Travel Time Reliability metrics.
(a) The State DOT shall calculate the TTTR Index metric (referred to as the TTTR metric) for each Interstate System reporting segment in accordance
with the following:
    (1) A truck travel time data set shall be created from the travel time data set to be used to calculate the TTTR metric. This data set shall include, for
    each reporting segment, a ranked list of average truck travel times, to the nearest second, for 15 minute periods of a 24-hour period for an entire calendar
    year that:
        (i) Includes ‘‘AM Peak’’ travel times occurring between the hours of 6 a.m. and 10 a.m. for every weekday (Monday –Friday) from January 1st through 
        December 31st of the same year;
        (ii) Includes ‘‘Mid Day’’ travel times occurring between the hours of 10 a.m. and 4 p.m. for every weekday (MondayFriday) from January 1st through 
        December 31st of the same year;
        (iii) Includes ‘‘PM Peak’’ travel times occurring between the hours of 4 p.m. and 8 p.m. for every weekday (Monday-Friday) from January 1st
        through December 31st of the same year;
        (iv) Includes ‘‘Overnight’’ travel times occurring between the hours of 8 p.m. and 6 a.m. for every day (SundaySaturday) from January 1st through
        December 31st of the same year; and
        (v) Includes ‘‘Weekend’’ travel times occurring between the hours of 6 a.m. and 8 p.m. for every weekend day (Saturday-Sunday) from January 1st
        through December 31st of the same year.
    (2) The Normal Truck Travel Time (50th percentile) shall be determined from each of the truck travel time data sets defined under paragraph (a)(1) of this 
    section as the time in which 50 percent of the times in the data set are shorter in duration and 50 percent are longer in duration. The 95th percentile 
    truck travel time shall be determined from each of the truck travel time data sets defined under paragraph (a)(1) of this section as the time in which 95
    percent of the times in the data set are shorter in duration. Both the Normal and 95th percentile truck travel times can be determined by plotting the data
    on a travel time cumulative probability distribution graph or using the percentile functions available in spreadsheet and other analytical tools.
    (3) Five TTTR metrics shall be calculated for each reporting segment; one for each data set defined under paragraph (a)(1) of this section as the
    95th percentile travel time divided by the Normal Truck Travel Time and rounded to the nearest hundredth.
(b) Starting in 2018 and annually thereafter, State DOTs shall report the TTTR metrics, as defined in this section, in accordance with the HPMS Field Manual by 
June 15th of each year for the previous year’s Freight Reliability measures.
    (1) All metrics shall be reported to HPMS by reporting segments. When the NPMRDS is used metrics shall be referenced by NPMRDS TMC(s) or HPMS section(s). 
    If a State DOT elects to use, in part or in whole, the equivalent data set, all reporting segment shall be referenced by HPMS section(s).
    (2) The TTTR metric shall be reported to HPMS for each reporting segment (to the nearest hundredths) for each of the five time periods identified in 
    paragraphs (a)(1)(i) through (v) of this section; the corresponding 95th percentile travel times (to the nearest second) and the corresponding normal
    (50th percentile) travel times (to the nearest second). 
*/
Create table `kytc-planning.NPMRDS.INRIX_F_LOTTTR_1` as 
with F_all_NA as (
    Select
        tmc_code as all_tmc_code,
        measurement_tstamp as all_measurement_tstamp,
        average_speed as all_average_speed,
        travel_time_minutes as all_travel_time_minutes
    from
        `kytc-planning.Inrix_TMC_Data.inrix_tmc_2017_Present_all`
        ),
F_TR_NA as (
    Select
        tmc_code as trucks_tmc_code,
        measurement_tstamp as trucks_measurement_tstamp,
        average_speed as trucks_average_speed,
        travel_time_minutes as trucks_travel_time_minutes
    from
        `kytc-planning.Inrix_TMC_Data.inrix_tmc_2017_Present_trucks`
        ),
F_ALL_AR as (
    Select
        tmc_code as all_tmc_code,
        measurement_tstamp as all_measurement_tstamp,
        speed as all_average_speed,
        travel_time_minutes as all_travel_time_minutes
    from
        `kytc-planning.Inrix_TMC_Data.inrix_tmc_2011_2016_all`
        ),
F_TR_AR as (
    Select
        tmc_code as trucks_tmc_code,
        measurement_tstamp as trucks_measurement_tstamp,
        speed as trucks_average_speed,
        travel_time_minutes as trucks_travel_time_minutes
    from
        `kytc-planning.Inrix_TMC_Data.inrix_tmc_2011_2016_trucks`
        )
-- This query is for Mon-Fri, 6AM-10AM, Truck Vehicles (HERE) - §490.611 (a) (1) (i)
select
    all_tmc_code,
    extract(YEAR from all_measurement_tstamp) as Year_Value,
    "TTTR_AMP" as Reporting_Bin,
    all_measurement_tstamp,
    (case 
        when trucks_average_speed is null 
        then all_average_speed 
        else trucks_average_speed end) as T_SPEED_FILLED,
    (case 
        when trucks_travel_time_minutes is null 
        then all_travel_time_minutes 
        else trucks_travel_time_minutes end) as T_Trav_Time_FILLED 
From
    F_all_NA
inner join
    F_TR_NA
    on all_tmc_code = trucks_tmc_code and all_measurement_tstamp = trucks_measurement_tstamp
where
    extract(HOUR from all_measurement_tstamp) > 5 
    and extract(HOUR from all_measurement_tstamp) < 10
    and extract(DAYOFWEEK from all_measurement_tstamp) > 1
    and extract(DAYOFWEEK from all_measurement_tstamp) < 7
union all
-- This query is for Mon-Fri, 10AM-4PM, Truck Vehicles (HERE) - §490.611 (a) (1) (ii)
select
    all_tmc_code,
    extract(YEAR from all_measurement_tstamp) as Year_Value,
    "TTTR_MIDD" as Reporting_Bin,
    all_measurement_tstamp,
    (case when trucks_average_speed is null then all_average_speed else trucks_average_speed end) as T_SPEED_FILLED,
    (case when trucks_travel_time_minutes is null then all_travel_time_minutes else trucks_travel_time_minutes end) as T_Trav_Time_FILLED 
From
    F_all_NA
inner join
    F_TR_NA
    on all_tmc_code = trucks_tmc_code and all_measurement_tstamp = trucks_measurement_tstamp
where
    extract(HOUR from all_measurement_tstamp) > 9 
    and extract(HOUR from all_measurement_tstamp) < 16
    and extract(DAYOFWEEK from all_measurement_tstamp) > 1
    and extract(DAYOFWEEK from all_measurement_tstamp) < 7
union all
-- This query is for Mon-Fri, 4PM-8PM, Truck Vehicles (HERE) - §490.611 (a) (1) (iii)
select
    all_tmc_code,
    extract(YEAR from all_measurement_tstamp) as Year_Value,
    "TTTR_PMP" as Reporting_Bin,
    all_measurement_tstamp,
    (case when trucks_average_speed is null then all_average_speed else trucks_average_speed end) as T_SPEED_FILLED,
    (case when trucks_travel_time_minutes is null then all_travel_time_minutes else trucks_travel_time_minutes end) as T_Trav_Time_FILLED 
From
    F_all_NA
inner join
    F_TR_NA
    on all_tmc_code = trucks_tmc_code and all_measurement_tstamp = trucks_measurement_tstamp
where
    extract(HOUR from all_measurement_tstamp) > 15 
    and extract(HOUR from all_measurement_tstamp) < 20
    and extract(DAYOFWEEK from all_measurement_tstamp) > 1
    and extract(DAYOFWEEK from all_measurement_tstamp) < 7
union all
-- This query is for Sat-Sun, 6AM-8PM, Truck Vehicles (HERE) - §490.611 (a) (1) (v)
select
    all_tmc_code,
    extract(YEAR from all_measurement_tstamp) as Year_Value,
    "TTTR_OVN" as Reporting_Bin,
    all_measurement_tstamp,
    (case when trucks_average_speed is null then all_average_speed else trucks_average_speed end) as T_SPEED_FILLED,
    (case when trucks_travel_time_minutes is null then all_travel_time_minutes else trucks_travel_time_minutes end) as T_Trav_Time_FILLED 
From
    F_all_NA
inner join
    F_TR_NA
    on all_tmc_code = trucks_tmc_code and all_measurement_tstamp = trucks_measurement_tstamp
where
    extract(HOUR from all_measurement_tstamp) > 5 
    and extract(HOUR from all_measurement_tstamp) < 20
    and (extract(DAYOFWEEK from all_measurement_tstamp) = 1
        or extract(DAYOFWEEK from all_measurement_tstamp) = 7)
union all
-- This query is for All Days, 8PM-6AM, Truck Vehicles (HERE) - §490.611 (a) (1) (iv)
select
    all_tmc_code,
    extract(YEAR from all_measurement_tstamp) as Year_Value,
    "TTTR_WE" as Reporting_Bin,
    all_measurement_tstamp,
    (case when trucks_average_speed is null then all_average_speed else trucks_average_speed end) as T_SPEED_FILLED,
    (case when trucks_travel_time_minutes is null then all_travel_time_minutes else trucks_travel_time_minutes end) as T_Trav_Time_FILLED 
From
    F_all_NA
inner join
    F_TR_NA
    on all_tmc_code = trucks_tmc_code and all_measurement_tstamp = trucks_measurement_tstamp
where
    (extract(HOUR from all_measurement_tstamp) > 20 
        or extract(HOUR from all_measurement_tstamp) < 5)
union all
-- This query is for Mon-Fri, 6AM-10AM, Truck Vehicles (HERE) - §490.611 (a) (1) (i)
select
    all_tmc_code,
    extract(YEAR from all_measurement_tstamp) as Year_Value,
    "TTTR_AMP" as Reporting_Bin,
    all_measurement_tstamp,
    (case when trucks_average_speed is null then all_average_speed else trucks_average_speed end) as T_SPEED_FILLED,
    (case when trucks_travel_time_minutes is null then all_travel_time_minutes else trucks_travel_time_minutes end) as T_Trav_Time_FILLED 
From
    F_all_AR
inner join
    F_TR_AR
    on all_tmc_code = trucks_tmc_code and all_measurement_tstamp = trucks_measurement_tstamp
where
    extract(HOUR from all_measurement_tstamp) > 5 
    and extract(HOUR from all_measurement_tstamp) < 10
    and extract(DAYOFWEEK from all_measurement_tstamp) > 1
    and extract(DAYOFWEEK from all_measurement_tstamp) < 7
union all
-- This query is for Mon-Fri, 10AM-4PM, Truck Vehicles (HERE) - §490.611 (a) (1) (ii)
select
    all_tmc_code,
    extract(YEAR from all_measurement_tstamp) as Year_Value,
    "TTTR_MIDD" as Reporting_Bin,
    all_measurement_tstamp,
    (case when trucks_average_speed is null then all_average_speed else trucks_average_speed end) as T_SPEED_FILLED,
    (case when trucks_travel_time_minutes is null then all_travel_time_minutes else trucks_travel_time_minutes end) as T_Trav_Time_FILLED 
From
    F_all_AR
inner join
    F_TR_AR
    on all_tmc_code = trucks_tmc_code and all_measurement_tstamp = trucks_measurement_tstamp
where
    extract(HOUR from all_measurement_tstamp) > 9 
    and extract(HOUR from all_measurement_tstamp) < 16
    and extract(DAYOFWEEK from all_measurement_tstamp) > 1
    and extract(DAYOFWEEK from all_measurement_tstamp) < 7
union all
-- This query is for Mon-Fri, 4PM-8PM, Truck Vehicles (HERE) - §490.611 (a) (1) (iii)
select
    all_tmc_code,
    extract(YEAR from all_measurement_tstamp) as Year_Value,
    "TTTR_PMP" as Reporting_Bin,
    all_measurement_tstamp,
    (case when trucks_average_speed is null then all_average_speed else trucks_average_speed end) as T_SPEED_FILLED,
    (case when trucks_travel_time_minutes is null then all_travel_time_minutes else trucks_travel_time_minutes end) as T_Trav_Time_FILLED 
From
    F_all_AR
inner join
    F_TR_AR
    on all_tmc_code = trucks_tmc_code and all_measurement_tstamp = trucks_measurement_tstamp
where
    extract(HOUR from all_measurement_tstamp) > 15 
    and extract(HOUR from all_measurement_tstamp) < 20
    and extract(DAYOFWEEK from all_measurement_tstamp) > 1
    and extract(DAYOFWEEK from all_measurement_tstamp) < 7
union all
-- This query is for Sat-Sun, 6AM-8PM, Truck Vehicles (HERE) - §490.611 (a) (1) (v)
select
    all_tmc_code,
    extract(YEAR from all_measurement_tstamp) as Year_Value,
    "TTTR_OVN" as Reporting_Bin,
    all_measurement_tstamp,
    (case when trucks_average_speed is null then all_average_speed else trucks_average_speed end) as T_SPEED_FILLED,
    (case when trucks_travel_time_minutes is null then all_travel_time_minutes else trucks_travel_time_minutes end) as T_Trav_Time_FILLED 
From
    F_all_AR
inner join
    F_TR_AR
    on all_tmc_code = trucks_tmc_code and all_measurement_tstamp = trucks_measurement_tstamp
where
    extract(HOUR from all_measurement_tstamp) > 5 
    and extract(HOUR from all_measurement_tstamp) < 20
    and (extract(DAYOFWEEK from all_measurement_tstamp) = 1
        or extract(DAYOFWEEK from all_measurement_tstamp) = 7)
union all
-- This query is for All Days, 8PM-6AM, Truck Vehicles (HERE) - §490.611 (a) (1) (iv)
select
    all_tmc_code,
    extract(YEAR from all_measurement_tstamp) as Year_Value,
    "TTTR_WE" as Reporting_Bin,
    all_measurement_tstamp,
    (case when trucks_average_speed is null then all_average_speed else trucks_average_speed end) as T_SPEED_FILLED,
    (case when trucks_travel_time_minutes is null then all_travel_time_minutes else trucks_travel_time_minutes end) as T_Trav_Time_FILLED 
From
    F_all_AR
inner join
    F_TR_AR
    on all_tmc_code = trucks_tmc_code and all_measurement_tstamp = trucks_measurement_tstamp
where
    (extract(HOUR from all_measurement_tstamp) > 20 
        or extract(HOUR from all_measurement_tstamp) < 5)