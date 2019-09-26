---
layout: page
title: Installation
permalink: /installation/
nav_order: 2
has_children: true
has_toc: false
---

## Prerequisites
The HRA Calculator is a Dockerized project.  Mac users will need to download and install the [Docker Desktop for Mac](https://docs.docker.com/docker-for-mac/install/) in order to deploy and manage the application.  Windows users will need to download and install the [Docker Desktop for Windows](https://docs.docker.com/docker-for-windows/install/).

## Architecture Overview
The application stack is divided into multiple different containers:

- **rails:** Ruby on Rails application that handles API requests 
- **angular:** Angular web frontend
- **mongo:** MongoDB database
- **redis:** In-memory key/value store 


There is a separate **docker-compose.yml** for [development](docker-compose.yml) and [production](docker-compose.prod.yml).  The development compose file will bring up the application locally in development mode, while the production compose file will deploy a production-like application locally.


## Local Deployment

To start up the application in your local Docker environment:

```bash
git clone https://github.com/ideacrew/hra_calculator.git
cd hra_calculator
docker-compose build
docker-compose up
```



