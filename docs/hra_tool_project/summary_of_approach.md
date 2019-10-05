---
layout: default
parent: HRA Tool Project
title: Summary of Approach
permalink: /hra_tool_project/summary_of_approach/
nav_order: 7
has_children: false
---

# Summary of Approach

While SBEs did not have time to fully integrate the new HRA rules into their application systems, it may be possible to modify static language in their application flow to capture individuals offered HRAs and get them the information they need.  Accordingly, the HRA tool is designed as a stand-alone web-based application that each SBE can stand up, customize, and then link to at key points in its application flow.  The tool will not share information back and forth with the main application, rather, it will ask the consumer the small number of (non-PII) questions needed to determine if the HRA is affordable and then provide the consumer guidance about how to proceed.

To allow each SBM to stand up it own instance of the tool, the project will deliver software which will be published to a public Github repository. The open source code base for the HRA Tool will be available for any hosting agency or individual to download a copy and utilize how they see fit. The first release of tool will be provide a fully functional external user facing anonymous experience available to any hosting agency designed to be a stand-alone feature or integrated into a software suite as needed.