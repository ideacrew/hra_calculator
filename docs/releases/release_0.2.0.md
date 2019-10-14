---
layout: page
title: Release 0.2.0
permalink: /hra_tool/releases/release_0.2.0/
parent: Releases
grand_parent: HRA Tool
has_children: false
nav_order: 2
---

_October 11, 2019_

Commit SHA: [Click Here](https://github.com/ideacrew/hra_calculator/commit/3e3bff0e982413cf00ea30190cbabb2f22f28d8e)

## Post-Deploy Smoke Testing Results from UAT instances:
- California = Pass
- District of Columbia = Pass
- Massachusetts = Pass
- New York = Pass 

## What’s Included in this Release?
Since the initial MVP soft launch on 10/7, the team has been busy making some adjustments to ensure the overall quality of the tool meets expectations. Below you can find the details about what is new:

- Most notably, the plan loading structure has changed to properly create and map the rating areas as originally intended. The upload process now requires every state to include all 3 SERFF templates as well as the county / zip-code mapping file. For states that do not use zip-code boundaries in their geographic rating model, they are not required to provide the zip-code values and can leave those rows blank. However, it is paramount that all states include the rating area values that must identically match the SERFF Rates template rating areas.
- Plan lookup for Marketplaces that use county-only for geographic rating boundaries
- Alphabetization of available counties in the dropdown
- Internal tightening of the code (specs)

## Remember 
If you have already downloaded the tool, you will need to download the latest version from Github (https://github.com/ideacrew/hra_calculator) and re-deploy to your instance. 

The HRA Tool Community site [Plans Page](https://ideacrew.github.io/hra_calculator/hra_tool/configuration/#plans-page---import-plan-information) section has been updated to reflect the latest plan loading instructions. 

If you run into issues or have questions please remember to route those through the [Issue Tracker](https://github.com/ideacrew/hra_calculator/issues).
