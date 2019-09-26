---
layout: page
title: Installation
permalink: /installation/
nav_order: 2
has_children: true
---

## Introduction
Given variation in SBE technical practices, the HRA Tool has been designed so that SBEs can easily deploy the application on a number of different platforms.  Instructions are provided below for each of these approaches:
- **Local Deployment:**  Deployment to a local Docker Desktop environment for development and testing
-	**AWS Deployment:**  Production-like deployment to an AWS cloud account
-	**Azure Deployment:**  Production-like deployment to an Azure cloud account
- **Data Center Deployment:**  Production-like deployment to on-premise virtual machines

The goal of the HRA Tool is to provide SBEs with an as close to turn-key solution as possible.  Because of this, we chose to package and deploy the application using Docker.  Docker gives us the ability to seamlessly build, share, and run the HRA Tool in any hosting environment - desktop, cloud, and on-premise.     

## Prerequisites
Because the HRA Tool is a Dockerized project, administrators and developers will need to download the Docker Desktop to deploy and manage the application.  Mac users will need to download and install the [Docker Desktop for Mac](https://docs.docker.com/docker-for-mac/install/), while Windows users will need to download and install the [Docker Desktop for Windows](https://docs.docker.com/docker-for-windows/install/).  The Docker Desktop installation includes Docker Engine, Docker CLI client, Docker Compose, Docker Machine, and Kitematic.


## Architecture Overview
The application stack is divided into multiple different containers:

- **rails:** Ruby on Rails application that handles API requests 
- **angular:** Angular web frontend
- **mongo:** MongoDB database
- **redis:** In-memory key/value store 


There is a separate **docker-compose.yml** for [development](docker-compose.yml) and [production](docker-compose.prod.yml).  The development compose file will bring up the application locally in development mode, while the production compose file will be used to deploy a production-like application locally.
