---
layout: default
title: Configuration
nav_order: 2
has_children: false
permalink: /hra_tool/configuration/
parent: HRA Tool
---
{: .no_toc }
# Configuration

The HRA Tool includes both a Web-facing Consumer Portal and a private Administrator Portal.  The Admin Portal is where you configure the system to follow the business rules and match the look and feel of your State-based Exchange system.  Unlike the Consumer Portal which is open to public access, the Admin Portal is is protected by account/password authentication and isolated into its own namespace which should be blocked from direct Internet access.

Here you will find step-by-step instructions on how to use the Admin Portal to customize the HRA Tool for your site.  These steps are:


{: .no_toc .text-delta }

1. TOC
{:toc}

## Initial Sign In

After verifying that the HRA Tool server and software is up and running, you may access the Admin Portal by pointing your Web browser to: my_hra_tool_server**/admin**.  This URL will route you to the Admin Portal's sign-in page.  

<img src="{{ site.base_url }}/img/hra-admin-portal.png" width="400" alt="sign in page">{: .pl-5 }

Under the HRA Tool [installation][1] process, the system initializes an account with the role: Enterprise Owner.  This account manages all aspects of the HRA Tool system, including accounts with the role: Marketplace Owner.  Use the credentials below to initially sign into the system:

Email
: admin@openhbx.org

Password
: ChangeMe!


>> **Note:** your computer must be on the same network as the server directly or via a VPN connection to access the HRA Tool Admin Portal.

## Enterprise Page - Create Your Marketplace

The first time you sign in, you will land on the Admin Portal's **Enterprise** page.  This is where you manage Marketplaces and accounts that may access their Administrator Portal.  

The HRA Tool is designed as a multi-tenant application enabling one infrastructure to host multiple Marketplaces.  The Enterprise sits at the top level of this hierarchy with Marketplaces below.  The system initializes an Enterprise with an administrator account in the role of *Enterprise Owner*.  The Enterprise Owner has full read and write access to all parts of the system.  This is the only account that may take that role.

The Enterprise Owner may create Marketplaces and assign accounts authorized to manage them. These accounts are assigned  *Marketplace Owner* role.  Marketplace Owners have full read and write access to their respective Marketplace only.  A Marketplace may have one or more Marketplace Owners.

Create a Marketplace in two simple steps:

1. Under New Account, create an account that will serve as the Marketplace Owner.  Enter an account name and password then click Add Account to create a new account.  
1. Under New Marketplace, select the State, enter a Marketplace Name (this is name that will appear on Consumer Portal), pick the account you created in first step as the Owner Account and click Add Marketplace.

The Navigation menu will update with the new Marketplace name along with access to the pages you will use to configure its appearance and behavior. 

## Profile Page - Add Your Brand

The **Profile** page is where you manage the User Interface (UI) theme and other elements that affect a Marketplace's Consumer Portal look and feel.  



## Features Page - Configure HRA Tool Calculations

The **Features** page offers configuration options to support your SBE's policies and plan offerings.  It's important to set your Marketplace's options before importing plan information.  As explained in the [Importing Plan Information](#plans-page---import-plan-information) section, these settings determine the type of data needed to determine HRA Affordability.  If these selections aren't made, the Plan import service may not accept your files, complaining about missing data.

There are two primary configuration settings on this page:

1. Use Age Rating?
1. Geographic Rating Area Model

These configurations determine how the system calculates HRA affordability and what information is collected on the Consumer Portal.

**Use Age Rating?** configures how the HRA Tool uses the plan premium tables.  If your SBE considers the consumer's age as a factor in determining plan premium amount, set this to **Yes**.  If your SBE uses a single premium rate regardless of the consumer's age, set this to **No**. 

**Geographic Rating Area Model** configures which plan premium table the HRA Tool uses to determine affodability.  The system supports three different models for Geographic Rating Areas.  Choose the model used by your SBE:

1. *Single Rating Area*: one premium rating area is used for the entire state
1. *County-based Rating Areas*: premium rating areas are defined on a county-by-county basis
1. *Zipcode-Based Rating Areas*: premium rating areas are defined on a county basis and below to zipcode areas

These configuration settings also manage what information is collected on the the Consumer Portal's **About You** page.  For example, setting **Use Age Rating?** to **Yes** will require the consumer enter a date of birth.  A **Geographic Area Rating Model**set to **Single Rating Area** will not collect any information related to the consumer's residence.  **County-based** and **Zipcode-Based** settings will collect requisite information necessary to find the premium rating table applicable to the consumer's residence.

## Plans Page - Import Plan Information

The **Plans** page enables you to upload plans, premiums, service and rating area data necessary to calculate HRA affordability.  Here you can import new plan data, view imported plans and delete all plan content from the database.  

The HRA Tool accepts source data in one of two file formats, depending on the content type.  Following is list of all file names and respective types used by the system:

| Source File Name | Description | File Type |
| :---------- | :---------- | :-------- |
| plan_and_benefits.xml | Individual Market Silver Plans in SERFF template XML output | XML |
| rates.xml | Premium rates in SERFF template XML output | XML |
| service_areas.xlsx | Plan Service Areas in SERFF Excel format | MS Excel Open XML | 
| county_zipcode.xlsx | Plan Service Areas in SERFF Excel format | MS Excel Open XML| 

The **Import SERFF Template** feature accepts plan data sets in zip file format structured as shown below. In [Release 0.2.0](), there was update provided to improve accuracy of the affordability alogorithm requiring, modifications to plan data requirements.

### Release 0.2.0 UPDATE

1. SERFF Templates will be the top-level folder
1. Each Carrier will have its own named folder nested within the SERFF Templates folder
1. Each Carrier folder must contain:
	 - Service Area template in .xlsx format
	 - Plan and Benefit template in .xml format
	 - Rates template in .xml format
1. The County / ZipCode mapping file is required for all states and must be in .xlsx format. The caveat is that only the states that use zip-code geographic rating areas need to populate the zip-code values in the table, otherwise the zip-code rows can be left blank under the zip-code header. __Important: The rating area naming convention used in the County / ZipCode mapping file must identically match the naming convention used in the Rates templates. The County / ZipCode file is not to be nested within a Carrier folder, but rather have its own folder nested within the SERFF Templates folder.__ An example of the zip file layout is found below:


```
serff_templates.zip
  |- [first_carrier_name]
  |    |- plan_and_benefits.xml
  |    |- rates.xml
  |    |- service_areas.xlsx
  |- [second_carrier_name]
       |- plan_and_benefits.xml
       |- rates.xml
       |- service_areas.xlsx
  |- county_zipcode.xlsx
  
```

The zip file set is organized into directories by carrier.  Names given to the carrier directories will appear in the plan table carrier column.  For best results, use snake case (words seperated by underscore '_') to name them.  For example, a directory named "first_carrier_name" will appear in the plan table as: "First Carrier Name"

>> You should include all carriers and all supporting data in a single zip file.  While the system will accept multiple uploads, unless all plan data is present the HRA Tool Consumer Portal may return incorrect determinations 
>> The County / ZipCode file is not to be nested within a Carrier folder, but rather have its own folder nested within the SERFF Templates folder.

A template mapping file is available here:

[Download County/Zipcode File Template](https://github.com/ideacrew/hra_calculator/tree/gh-pages/assets/documents/county_zipcode.xlsx){: .btn .btn-primary .fs-5 .mb-4 .mb-md-0 .mr-2 }


## Tool UI Page - Customize Communication with Your Consumers

In the [MVP Release](https://ideacrew.github.io/hra_calculator/hra_tool/releases/mvp_release/), this page allows the Enterprise owner and/or Marketplace owners to directly input desired text and format for each of the following attributes. At installation the platform will come prepopulated with the "Current Text". These attributes may appear across multiple pages in the anonymous user experience. 

| Template Name	| Current Text |
|:------------- |:------------ |
| page_title | HRA Affordability Tool |
| a_tax_credit | a tax credit	|
| market_place | MARKETPLACE |
| how_to_enroll |	HOW TO ENROLL THROUGH MARKETPLACE WITHOUT APTC |
| off_market | similar coverage off Marketplace	|
| results_page_help_text_1 | The results above are based on the information provided, which has not been independently verified. This is not a determination that you are eligible for a tax credit. |
| results_page_help_text_2 | When you’re asked to set your tax credit amount, reduce what you accept by your monthly HRA amount to help avoid having to pay back money at tax time. |
| answer_no |	Answer “no” when asked if you’re offered health insurance by an employer (unless you are separately offered health insurance by another employer). |
| aca_compliant |	an ACA-compliant plan off Marketplace. Ask your employer about your options. |
| minimum_essential_coverage | minimum essential coverage |
| minimum_essential_coverage_link |	https://www.healthcare.gov/fees/plans-that-count-as-coverage/ |
| short_term_plan | such as a short-term plan |


[1]: ../installation
