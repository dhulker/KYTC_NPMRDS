
Create table `kytc-planning.NPMRDS.INRIX_TMC_E_5` as 
Select
    INRIX_TMC1,
    inrix_year,		
    Vehicle_Type,	
    max(LOTTR) as MX_LOTTR
From
    `kytc-planning.NPMRDS.INRIX_TMC_E_4`
GROUP BY
    INRIX_TMC1,
    inrix_year,
    Vehicle_Type	