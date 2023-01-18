Create table `kytc-planning.NPMRDS.INRIX_F_LOTTTR_2` as 
Select
    all_tmc_code,	
    extract(DAYOFYEAR from all_measurement_tstamp) as date_value,
    Year_Value,	
    Reporting_Bin,
    floor((extract(HOUR from all_measurement_tstamp) 
        + extract(MINUTE from all_measurement_tstamp) 
        / 0.6 / 100) * 12 / 3) / 4 as TOD_value, -- This creates the 15 minute bins out of 5 minute records
    -- all_measurement_tstamp,
    avg(T_SPEED_FILLED) as Average_Truck_Speed,
    avg(T_Trav_Time_FILLED) as Average_Truck_TT
From 
    `kytc-planning.NPMRDS.INRIX_F_LOTTTR_1`
Where
    T_SPEED_FILLED is not null
    and T_Trav_Time_FILLED is not null
Group by
    all_tmc_code,	
    Year_Value,	
    Reporting_Bin,
    floor((extract(HOUR from all_measurement_tstamp) 
        + extract(MINUTE from all_measurement_tstamp) 
        / 0.6 / 100) * 12 / 3) / 4,
extract(DAYOFYEAR from all_measurement_tstamp)