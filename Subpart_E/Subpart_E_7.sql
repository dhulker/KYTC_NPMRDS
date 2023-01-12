Create table `kytc-planning.NPMRDS.INRIX_TMC_E_7` as 
Select
    inrix_year,		
    Vehicle_Type,
    "MPO_AREA" as Area_type,
    -- PM3_F_System,		
    -- PM3_Urban_Code,	
    -- KYTC_CO_NUM,	
    -- KYTC_CO,	
    -- kytc_district,	
    KYTC_MPO_PL_AREA,	
    -- KYTC_MPO_URBAN_AREA,	
    -- KYTC_ADD,	
    -- KYTC_Inc_Area,	
    -- IF(PM3_F_System = 1, "INTERSTATE", "NHS") as F_System,
    case when 
        RITIS_F_System = 1 
        AND (RITIS_FacilType = 1 OR RITIS_FacilType = 2 OR RITIS_FacilType = 6)
        AND RITIS_NHS > 0
        Then "INTERSTATE"
        Else "NHS" END as F_System,
    sum(RITIS_Miles) as Total_miles,
    SUM(ANN_VOL_MI) as Total_PersonMiles,
    SUM(GOOD_MILES) as Total_Good_PersonMiles,
    SUM(GOOD_MILES) / SUM(ANN_VOL_MI) as PERCENT_RELIABLE_E
From
    `kytc-planning.NPMRDS.INRIX_TMC_E_6`
Group by
    inrix_year,		
    Vehicle_Type,
    -- PM3_F_System,		
    -- PM3_Urban_Code,	
    -- KYTC_CO_NUM,	
    -- KYTC_CO,	
    -- kytc_district,	
    KYTC_MPO_PL_AREA,	
    -- KYTC_MPO_URBAN_AREA,	
    -- KYTC_ADD,	
    -- KYTC_Inc_Area,
    case when 
        RITIS_F_System = 1 
        AND (RITIS_FacilType = 1 OR RITIS_FacilType = 2 OR RITIS_FacilType = 6)
        AND RITIS_NHS > 0
        Then "INTERSTATE"
        Else "NHS" END