/*
    (2) The Normal Travel Time (50th percentile) shall be determined from each data 
    set defined under paragraph (b)(1) of this section as the time in which 50 percent 
    of the times in the data set are shorter in duration and 50 percent are longer in 
    duration. The 80th percentile travel time shall be determined for each data set 
    defined under paragraph (b)(1) of this section as the time in which 80 percent of 
    the times in the data set are shorter in duration and 20 percent are longer in 
    duration. Both the Normal and 80th percentile travel times can be determined by 
    plotting the data on a travel time cumulative probability distribution graph or 
    using the percentile functions available in spreadsheet and other analytical tools.
    (3) Four LOTTR metrics shall be calculated for each reporting segment; one for 
    each data set defined under paragraph (b)(1) of this section as the 80th percentile 
    travel time divided by the 50th percentile travel time and rounded to the nearest 
    hundredth.
(c)-(d) [Reserved]
(e) Starting in 2018 and annually thereafter, State DOTs shall report the LOTTR metrics, 
defined in paragraph (b) of this section, in accordance with HPMS Field Manual by June 
15th of each year for the previous year's measures.
    (1) Metrics are reported to HPMS by reporting segment. All reporting segments where 
    the NPMRDS is used shall be referenced by NPMRDS TMC(s) or HPMS section(s). If a State 
    DOT elects to use, in part or in whole, the equivalent data set, all reporting segment 
    shall be referenced by HPMS section(s); and
    (2) The LOTTR metric (to the nearest hundredths) for each of the four time periods 
    identified in paragraphs (b)(1)(i) through (iv) of this section: the corresponding 
    80th percentile travel times (to the nearest second), the corresponding Normal 
    (50th percentile) Travel Times (to the nearest second), and directional AADTs. If a 
    State DOT does not elect to use FHWA supplied occupancy factor, as provided in 
    § 490.507(d), that State DOT shall report vehicle occupancy factor (to the nearest 
    tenth) to HPMS.
(f) [Reserved]
[82 FR 6031, Jan. 18, 2017, as amended at 83 FR 24936, May 31, 2018]
*/
Create table `kytc-planning.NPMRDS.INRIX_TMC_E_3` as 
Select
    INRIX_TMC1,
    inrix_year,		
    Reporting_Bin,
    Vehicle_Type,	
    time_of_day_value,
    weekdays_value,	
    -- LOTTR is 80th / 50 Travel Time
    TT_Percentiles[offset(50)] as TT50th, -- 490.511
    TT_Percentiles[offset(80)] as TT80th, -- 490.511
    Speed_Percentiles[offset(50)] as Speed_50th, 
    Speed_Percentiles[offset(20)] as Speed_20th -- The 20th Speed corresponds to the 80th travel time
From
    `kytc-planning.NPMRDS.INRIX_TMC_E_2`
