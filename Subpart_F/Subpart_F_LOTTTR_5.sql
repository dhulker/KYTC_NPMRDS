Create Table `kytc-planning.NPMRDS.INRIX_F_LOTTTR_5` as
Select
    all_tmc_code,
    Year_Value,
    Reporting_Bin,
    TT50th, 
    TT95th, 
    Speed_50th, 
    Speed_5th,    
    -- LOTTTR is 95th / 50th Travel Time
    -- This traps div/0 errors and sets them to 1.  
    IF(SAFE_DIVIDE(TT95th, TT50th) is NULL, 1, TT95th / TT50th) as LOTTTR
From
    `kytc-planning.NPMRDS.INRIX_F_LOTTTR_4`