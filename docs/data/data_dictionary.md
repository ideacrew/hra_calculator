---
layout: default
title: Data Dictionary
nav_order: 2
has_children: false
---

# Data Dictionary

The HRA Tool uses a combination of factors, health care plans, and consumer-supplied data elements as inputs to determine HRA affordability.  Consumer-supplied data requirements are minimized both to make the application simple to use and preserve consumers' anonymity.  The data dictionary detailed in the table below list primary elements entered and stored in the system.


| Element Name        | Type | Description | Source | Notes | 
| ------------------- | ---- | ------ | ----- |
| date_of_birth
| residence_county
| residence_state
| residence_zip_code
| annual_gross_income |
| hra_kind
| hra_amount
| hra_start_date
| hra_end_date
| us_state
| us_county
| plan_name
| plan_hios_id
| plan_premium
| plan_service_area
| plan_rating_area
| zip_code


In order to reach an affordability determination, the system utilizes inputs from the end-user as well as inputs derived from the SERFF templates themselves. The values are then fed into the affordability algorithm and the result is displayed to the end-user accordingly. The Data Dictionary is the logical representation of the data that is temporarily housed in the db to facilitate a successful affordability determination. The end-user has the ability to edit their inputs from the results page which will automatically overwrite any previous value staged in the db, and all user inputs plus the determination result will be destroyed upon exiting or restarting the tool. TheData Dictionary can be broken down into different categorizations of data which can be referred to as User inputs, System inputs, and Determination 

User Inputs:

Attribute NameAttribute TypeRequired?DefaultValueNotes:zipcodeString.default(' '.freeze)ConditionalNull:countyString.default(' '.freeze)ConditionalNull:dobDateConditionalNull:household_frequencyStringYesNullMonthly or Annual:household_amountFloatYesNull:hra_typeStringYesNullICHRA or QSEHRA:start_monthDateYesNull:end_monthDateYesNull:hra_frequencyStringYesNullMonthly or Annual:hra_amountFloatYesNullSystem Inputs:Attribute NameAttribute TypeRequired?Default ValueNotes:stateStringYesNull:plan_hios_idStringYesNull:plan_nameStringYesNull:member_premiumFloat.default(0.00.freeze)Yes0.00:ageInteger.default(0.freeze)Yes0:hraFloat.default(0.00.freeze)Yes0.00:rating_area_idString.meta(omittable: true)YesNull
:service_area_idsArray.of(Types::String).meta(omittable: true)YesNull:errorsArray.default([].freeze)ConditionalNullDetermination:Attribute NameAttribute TypeRequired?Default ValueNotes:hra_determinationString.default('No Determination'.freeze)YesNull
