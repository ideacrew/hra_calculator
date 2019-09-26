---
layout: page
title: Local Deployment
permalink: /local_deployment/
parent: Installation
nav_order: 1
---

## Local Deployment
When deploying the application locally, you have a couple of different options.  The first option is to start the application in development mode.  In development mode, the application is provisioned to allow for a faster development cycle.  In production mode, the application is provisioned to mimic how it will be deployed on the server.

### Development Mode 
To start up the application in your local Docker environment in development mode:

```
git clone https://github.com/ideacrew/hra_calculator.git
cd hra_calculator
docker-compose build
docker-compose up
```
This starts the application on port 4200 in a terminal window where log output can be seen.  If you prefer to run the application as a background process, use `docker-compose up -d`.  Once the application is up, go to `http://localhost:4200` to test it.
### Production Mode
If you prefer to start up the application in your local Docker environment in production mode:

```
git clone https://github.com/ideacrew/hra_calculator.git
cd hra_calculator
docker-compose build -f docker-compose.prod.yml
docker-compose up -f docker-compose.prod.yml
```
This starts the application on port 8080 in a terminal window where log output can be seen.  If you prefer to run the application as a background process, use `docker-compose up -d`.  Once the application is up, go to `http://localhost:8080` to test it.



