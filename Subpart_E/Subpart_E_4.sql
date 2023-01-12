
Create table `kytc-planning.NPMRDS.INRIX_TMC_E_4` as 
Select
    INRIX_TMC1,
    inrix_year,		
    Reporting_Bin,
    Vehicle_Type,	
    time_of_day_value,
    weekdays_value,	
    -- LOTTR is 80th / 50 Travel Time
    -- This traps div/0 errprs and sets them to 1
    IF(SAFE_DIVIDE(TT80th, TT50th) is NULL, 1, TT80th / TT50th) as LOTTR
    -- TT_Percentiles[offset(50)] as TT50th, -- 490.511
    -- TT_Percentiles[offset(80)] as TT80th, -- 490.511
    -- Speed_Percentiles[offset(50)] as Speed_50th, 
    -- Speed_Percentiles[offset(20)] as Speed_20th -- The 20th Speed corresponds to the 80th travel time
From
    `kytc-planning.NPMRDS.INRIX_TMC_E_3`