---
layout: page
title: Local Deployment
permalink: /local_deployment/
parent: Installation
nav_order: 1
---

## Local Deployment
To start up the application in your local Docker environment:

```
git clone https://github.com/ideacrew/hra_calculator.git
cd hra_calculator
docker-compose build
docker-compose up
```
This starts the application on port 8080 in a terminal window where log output can be seen.  If you prefer to run the application as a background process, use `docker-compose up -d`.  Once the application is up, go to `http://localhost:8080` to test it.


