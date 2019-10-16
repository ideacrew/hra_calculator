---
layout: page
title: Local Deployment
permalink: /hra_tool/installation/local_deployment/
parent: Installation
grand_parent: HRA Tool
nav_order: 1
---

## Local Deployment
When deploying the application locally, you have a couple of different options.  The first option is to start the application in development mode.  In development mode, the application is provisioned to allow for a faster development cycle.  In production mode, the application is provisioned to mimic how it will be deployed on the server.

### Development Mode 
To prep your local environment to run the app you need to create Rails credentials.  To do so, run the following commands.  This will pull down the repo, remove the default credentials and generate new credentials.  A vi window will be opened, just type ":q!" to exit.  

```
git clone https://github.com/ideacrew/hra_calculator.git
cd hra_calculator
rm -f config/credentials.yml.enc
docker-compose run --rm runner rails credentials:edit 
```

Now, to start up the application in your local Docker environment in development mode, run the following commands:

```
docker-compose -f docker-compose.dev.yml build
docker-compose -f docker-compose.dev.yml up
```

This starts the application on port 4200 in a terminal window where log output can be seen.  If you prefer to run the application as a background process, use `docker-compose -f docker-compose.dev.yml up -d`.  Once the application is up, go to `http://localhost:4200` to test it.

To bring down the application simply run:

```
docker-compose -f docker-compose.dev.yml down
```

### Production Mode
You also have the ability to start up the application locally in a manner that will mimic a production deployment.  Before doing so, you will need to either procure CA certs or generate self-signed certs.  For the purpose of testing locally, generating self-signed certs will suffice.  Go to a directory where you will clone your the hra_calculator repo and run the following commands and follow the prompts:

```
mkdir certs
openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out certs/fullchain.pem -keyout certs/privkey.pem
```

To prep your local environment to run the app you need to create Rails credentials.  To do so, run the following commands.  This will pull down the repo, remove the default credentials and generate new credentials.  A vi window will be opened, type ":q!" to exit. 

```
git clone https://github.com/ideacrew/hra_calculator.git
cd hra_calculator
rm -f config/credentials.yml.enc
docker-compose run --rm runner rails credentials:edit 
```
Now, to start up the application in your local Docker environment in production mode run the following commands:

``` 
docker-compose -f docker-compose.prod.yml build 
docker-compose -f docker-compose.prod.yml up 
```

This starts the application on port 8080 in a terminal window where log output can be seen.  If you prefer to run the application as a background process, use `docker-compose -f docker-compose.prod.yml up -d`.  Once the application is up, go to `http://localhost:8080` to test it.

To bring down the application simply run:

```
docker-compose -f docker-compose.prod.yml down
```



