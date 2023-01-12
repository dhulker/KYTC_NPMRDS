Create table `kytc-planning.NPMRDS.INRIX_TMC_E_6` as 
Select
    INRIX_TMC1,
    inrix_year,		
    Vehicle_Type,	
    MX_LOTTR,
    -----------------------------------------------------------------------------------
    -- https://npmrds.ritis.org/analytics/help/#data-types
    /* f_system — The FHWA-approved Functional Classification System code. If multiple 
    HPMS segments with different attribute values are assigned to a single TMC path, the 
    value for the highest functional class (minimum code value) is assigned.
        1 = Interstate                          
        2 = Principal Arterial – Other Freeways and Expressways
        3 = Principal Arterial – Other
        4 = Minor Arterial
        5 = Major Collector
        6 = Minor Collector
        7 = Local */
    PM3_F_System,		
    PM3_Urban_Code,		
    /* faciltype — The operational characteristic of the roadway. If multiple HPMS 
    segments with different attribute values are assigned to a single TMC path, the 
    predominant value by length is assigned.
        1 = One-Way Roadway
        2 = Two-Way Roadway
        3 = Ramp
        4 = Non Mainlane
        5 = Non Inventory Direction
        6 = Planned/Unbuilt */ 
    PM3_Facility_Type,		
    PM3_NHS,		
    PM3_Segment_Length,		
    PM3_Directionality,		
    PM3_DIR_AADT,		
    -----------------------------------------------------------------------------------
    /* the type of tmc code. 
        "P1" is the typical TMC Code. 
        "P3" indicates national, state, and county boundaries, rest areas, toll plazas, major bridges, etc. 
        "P4" is for ramps. */
    RITIS_TmcType,
    RITIS_Miles,	
    RITIS_F_System,	
    RITIS_Urban_Code,	
    RITIS_FacilType,	
    RITIS_StrucType,
    RITIS_AADT,	
    RITIS_NHS,	
    RITIS_NHS_Pct,	
    -----------------------------------------------------------------------------------
    KYTC_CO_NUM,	
    KYTC_CO,	
    kytc_district,	
    KYTC_MPO_PL_AREA,	
    KYTC_MPO_URBAN_AREA,	
    KYTC_ADD,	
    KYTC_Inc_Area,	
    -----------------------------------------------------------------------------------
    -- Annual Person-Miles = ADT X 365 X segment length X occupancy factor -- 490.509 (c)
    -- Calculates the denomenator of the equation specified in 490.513 (b) and (c)
    PM3_DIR_AADT * 365 * (RITIS_Miles * RITIS_NHS_Pct) * 1.7 as ANN_VOL_MI, 
    -- Calculates segments exhibiting an LOTTR below 1.5 per 490.513 (b) and (c)
    -- Calculates the numerator of the equation specified in 490.513 (b) and (c)
    if(MX_LOTTR < 1.5, PM3_DIR_AADT * 365 * (RITIS_Miles * RITIS_NHS_Pct) * 1.7, 0) as GOOD_MILES
From
    `kytc-planning.NPMRDS.INRIX_TMC_E_5`
INNER JOIN
    `kytc-planning.Inrix_TMC_Metadata.INRIX_TMC_Metadata`
    on PM3_Travel_Time_Code = INRIX_TMC1
    and PM3_Year_Record = inrix_year