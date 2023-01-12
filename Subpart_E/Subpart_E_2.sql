-- Subpart E 2
Create table `kytc-planning.NPMRDS.INRIX_TMC_E_2` as 
Select
    INRIX_TMC1,
    sum(TMC_ROW_COUNT) as TMC_BIN_Count,	
    -- inrix_date1,	
    inrix_year,	
    Reporting_Bin,
    -- TOD_value,	
    Vehicle_Type,	
    time_of_day_value,
    weekdays_value,	
    approx_quantiles(speed_Mph, 100) as Speed_Percentiles,	
    approx_quantiles(Travel_time_seconds, 100) as TT_Percentiles	
    -- Speed_Mph,	
    -- Travel_time_seconds	
From
    `kytc-planning.NPMRDS.INRIX_TMC_E_1`
Group by
    INRIX_TMC1,	
    inrix_year,	
    Reporting_Bin,
    Vehicle_Type,	
    time_of_day_value,
    weekdays_value