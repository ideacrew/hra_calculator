---
layout: default
title: Data Dictionary
nav_order: 3
permalink: /hra_tool/data_dictionary/
has_children: false
parent: HRA Tool
---

# Data Dictionary

The HRA Tool uses a combination of factors, health care plans and premiums, and consumer-supplied data elements as inputs to determine HRA affordability.  Consumer-supplied data requirements are minimized both to make the application simple to use and preserve consumers' anonymity.  The data dictionary detailed in the table below list primary elements entered and stored in the system.


| Element Name        | Type | Description | Source | Notes |
| :------------------ | :--- | :----- | :----- |
| residence_state | string | state name for employee's home address | system configured | |
| residence_county | string | county name for employee's home address | consumer entered | collected only when configured to use > 1 geographic rating area |
| residence_zip_code | string | zip code for employee's home address | consumer entered | collected only when configured to use > 1 geographic rating area |
| date_of_birth | date | employee's birth date | consumer entered | collected only when configured to use age based rating |
| annual_gross_income | integer | estimated household income for the determination year | consumer entered | |
| hra_kind | string | enumerated value of 'qsehra' or 'ichra' | consumer entered | |
| hra_annual_amount | integer | employer HRA contribution amount for the determination year | consumer entered | |
| hra_start_date | date | date employer HRA begins | consumer entered | |
| hra_end_date | date | date employer HRA ends | consumer entered | |
| health_plan_name | string | issuer-assigned name for silver plan | SERFF template | |
| health_plan_hios_id | string | unique identifier for silver plan | SERFF template | |
| health_plan_service_area | string | geographic area where a silver plan is offered | SERFF template | indexed by state, county or county+zipcode  |
| health_plan_rating_area | string | geographic area with a single premium rate table for a plan | SERFF template | |
| health_plan_premium | float | premium amount for a plan within a plan_rating_area | system calculated | indexed by age when configured to use age based rating |
| lowest_cost_silver_plan_id | string | indentifier for lowest cost silver plan in a geographic rating area | system calculated | used for ICHRA affordability determinations |
| second_lowest_cost_silver_plan_id | string | indentifier for second lowest cost silver plan in a geographic rating area | system calculated | used for QSEHRA affordability determinations |
| determination_result | string | enumerated value of 'affordable' or 'unaffordable' | system calculated | |

