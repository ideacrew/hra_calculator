---
layout: page
title: Introduction
permalink: /introduction/
parent: Getting Started
nav_order: 1
---

## Challenge

New federal rules on HRAs were adopted too late to be fully integrated into State Based Exchange (SBE) application systems, creating the risk of consumer errors that could result in large tax bills or missing out on coverage options. 

## Objective

State Health & Value Strategies (SHVS) and IdeaCrew have developed a web-based decision support tool that will calculate employee costs based on employer’s monthly contribution amount. The tool will help consumers understand their options for obtaining health coverage and affordability based on employer-offered HRA type and contribution amount. The tool will also provide consumers with educational material, resources, and web links. 
For State-based Exchanges (SBEs) and other hosting agencies, the HRA Tool offers simple setup with tenant-based site branding and configuration with state-level information so that it may be used across the country. 

## Background

The Qualified Small Employer Health Reimbursement Arrangement (QSEHRA) enables small employers to establish a company-funded, tax-advantaged benefit to reimburse consumers for personal health care expenses, including individual market coverage. QSEHRAs are available to employers with 50 or fewer employees and caps benefit amounts at $5,150 for employee-only coverage and $10,450 for consumers with dependents (2019 amounts). To qualify for a QSEHRA, consumers must enroll in minimum essential coverage. Employees offered QSEHRAs considered “affordable” are ineligible for ACA the premium tax credit (PTC), and employees offered “unaffordable” QSEHRAs must reduce their PTC (if otherwise eligible) by the amount of the QSEHRA.

The Individual Coverage Health Reimbursement Arrangement (ICHRA) is a new program for which regulations were finalized in June 2019. ICHRAs enable employers to establish a company-funded, tax-advantaged benefit to reimburse consumers for personal health care expenses, including individual market coverage. ICHRAs are available to employers of any size, there are no benefit caps, and employers may vary eligibility and benefit amount by employee class. To qualify for an ICHRA, consumers must purchase individual health coverage or be enrolled in Medicare. Consumers offered “affordable” ICHRAs or who accept their ICHRA aren’t eligible for the PTC. For employees offered an unaffordable ICHRA and eligible for the PTC, the PTC is generally larger.

At present, the ACA Marketplaces consumers have not generally had time to incorporate the QSEHRA and ICHRA rules into their application architecture.  As a result, individuals offered these HRAs are at risk of receiving incomplete or incorrect information about their APTC eligibility and coverage options. 

## Summary of Approach

While SBEs did not have time to fully integrate the new HRA rules into their application systems, it may be possible to modify static language in their application flow to capture individuals offered HRAs and get them the information they need.  Accordingly, the HRA tool is designed as a stand-alone web-based application that each SBE can stand up, customize, and then link to at key points in its application flow.  The tool will not share information back and forth with the main application, rather, it will ask the consumer the small number of (non-PII) questions needed to determine if the HRA is affordable and then provide the consumer guidance about how to proceed.

To allow each SBM to stand up it own instance of the tool, the project will deliver software which will be published to a public Github repository. The open source code base for the HRA Tool will be available for any hosting agency or individual to download a copy and utilize how they see fit. The first release of tool will be provide a fully functional external user facing anonymous experience available to any hosting agency designed to be a stand-alone feature or integrated into a software suite as needed.

