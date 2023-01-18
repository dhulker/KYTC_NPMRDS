Create Table `kytc-planning.NPMRDS.INRIX_F_LOTTTR_4` as
Select
    all_tmc_code,
    Year_Value,
    Reporting_Bin,
    Truck_TT_Percentiles[offset(50)] as TT50th, 
    Truck_TT_Percentiles[offset(95)] as TT95th, 
    Speed_Percentiles[offset(50)] as Speed_50th, 
    Speed_Percentiles[offset(5)] as Speed_5th
From
    `kytc-planning.NPMRDS.INRIX_F_LOTTTR_3`