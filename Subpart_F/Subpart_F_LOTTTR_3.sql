Create table `kytc-planning.NPMRDS.INRIX_F_LOTTTR_3` as
select
    all_tmc_code,
    Year_Value,
    Reporting_Bin,
    approx_quantiles(Average_Truck_Speed, 100) as Speed_Percentiles,	
    approx_quantiles(Average_Truck_TT * 60, 100) as Truck_TT_Percentiles
From
    `kytc-planning.NPMRDS.INRIX_F_LOTTTR_2` 
group By
    all_tmc_code,
    Year_Value,
    Reporting_Bin