---
layout: default
title: Configuration
nav_order: 3
has_children: false
---
# Configuration

The HRA Tool includes both a Web-facing Consumer Portal and a private Administrator Portal.  The Admin Portal is where you configure the system to follow the business rules and match the look and feel of your State-based Exchange system.  Unlike the Consumer Portal which is open to public access, the Admin Portal is isolated into its own namespace which may be blocked from direct Internet access and is protected by account/password authentication.  

This section explains how to use the Admin Tool to customize the HRA Tool for your site.  These functions include:

1. [Initial Sign In](#initial-sign-in)
1. [Creating Your Marketplace](#creating-your-marketplace)
2. [Adding Branding](#adding-branding)
3. [Configuring HRA Tool Calculations](#configuring_hra_tool_calculations)
4. [Importing Plan Information](importing_plan_information)
5. [Customizing the Consumer Interface](#customizing-the-consumer-interface)


## Initial Sign In

Under the HRA Tool [installation][1] process, the system initializes an owner account.  After verifying that the HRA Tool server and software is up and running, you may access the Admin Portal by pointing your Web browser to: my_hra_tool_server**/admin**.  

This will route you to the Admin Portal sign-in page.  Use the credentials below to initially sign into the system:

Account: 
: admin@openhbx.org

Password: 
: ChangeMe!


>> *Note that your computer must be on the same network as the server or use a VPN or similar to access the HRA Tool Admin Portal.*

## Creating Your Marketplace

The first time you sign in, you will land on the Admin Portal's **Enterprise** page.  

2. On Enterprise page:
2.1. Create account owner for Marketplace
2.2. Create Marketplace

## Adding Branding




## Configuring HRA Tool Calculations

The **Features** page offers configuration options to support your SBE's policies and plan offerings.  You must choose configuration options for your Marketplace on the before importing plan information.  Otherwise, the HRA Tool may fail import validation due to missing SERFF template files.

You can choose whether the system uses the consumer's age and associated premium amount as an affordability determination factor.  Set the **Use Age Ratings?** option to **Yes** if your SBE uses age ratings for plan premiums, otherwise set it to **No**

The system supports three different models for Geographic Rating Areas:

1. *Single Rating Area*: one premium rating area is used for the entire state
1. *County-based Rating Areas*: premium rating areas are defined on a county-by-county basis
1. *Zipcode-Based Rating Areas*: premium rating areas are defined on a county basis and below to zipcode areas

Choose the Geographic Rating Model used by your SBE.  

## Importing Plan Information

The *Plans* page enables you to upload plans, premiums, service and rating area data necessary to calculate the HRA affordability.  You can import and view already imported plan information on this page.  

The Plan Import SERFF Template feature accepts plan data content in .zip file format.  The file set is expected in a structured format as shown here:

```
serff_templates.zip
  |- [first_carrier_name]
  |    |- plan_and_benefit.xml
  |    |- rates.xml
  |    |- service_areas.xml
  |- [second_carrier_name]
       |- plan_and_benefit.xml
       |- rates.xml
       |- service_areas.xml
```


The kinds of data the HRA Tool expects depends upon the configuration options selected on the **Features** page.  The tables below show the configuration settings and corresponding files must be present in the .zip file.  

>> *If any required files are missing the system will not import the file set.*

File data required for Use Age Ratings?:

| Use Age Ratings? | plan_and_benefit.xml | rates.xml |
| :--------------: | :------------------: | :-------: |
| Yes              | X                    | X         |
| No               | X                    |           |

File data required for Geographic Rating Area:

| Geographic Rating Area    | service_areas.xml | county_zipcode.xlsx |
| :----                     | :------:          | :-----:             |
| Single Rating Area        |                   |                     |
| County-based Rating Area  | X                 |                     |
| Zipcode-based Rating Area | X                 | X                   |


The Plan Import County/ZipCode Mapping File feature supports loading of supplemental rating area infomration when Geographic Rataing Model option is set to: Zipcode-based Rating Areas.  Like the SERFF Templates, the import function expects a .zip file.  In this case, it will include only one file named: **county_zipcode.xslx**
County-Zip as MS Excel .xslx format

## Customizing the Consumer Interface


[1]: ../../installation