---
layout: page
title: Installation
permalink: /installation/
nav_order: 2
has_children: true
---

## Prerequisites
The HRA Calculator is a Dockerized project.  Mac users will need to download and install the [Docker Desktop for Mac](https://docs.docker.com/docker-for-mac/install/) in order to deploy and manage the application.  Windows users will need to download and install the [Docker Desktop for Windows](https://docs.docker.com/docker-for-windows/install/).  The Docker Desktop installation includes Docker Engine, Docker CLI client, Docker Compose, Docker Machine, and Kitematic.


## Architecture Overview
The application stack is divided into multiple different containers:

- **rails:** Ruby on Rails application that handles API requests 
- **angular:** Angular web frontend
- **mongo:** MongoDB database
- **redis:** In-memory key/value store 


There is a separate **docker-compose.yml** for [development](docker-compose.yml) and [production](docker-compose.prod.yml).  The development compose file will bring up the application locally in development mode, while the production compose file will be used to deploy a production-like application locally.


## Local Deployment
To start up the application in your local Docker environment:

```
git clone https://github.com/ideacrew/hra_calculator.git
cd hra_calculator
docker-compose build
docker-compose up
```
This starts the application on port 8080 in a terminal window where log output can be seen.  If you prefer to run the application as a background process, use `docker-compose up -d`.  Once the application is up, go to `http://localhost:8080` to test it.


## Production Deployment
For production deployments, Docker Swarm will be used.  Swarm is a Docker-native clustering system.  It turns a pool of Docker hosts into a single, virtual host using an API proxy system.  The instructions below describe how to provision a single node swarm.  Instructions on how to add nodes to the swarm cluster can be found [here](https://docs.docker.com/v17.09/get-started/part4/#set-up-your-swarm).

### Set Up Your Swarm
In order to deploy to a Docker swarm, you have to provision one or more physical or virtual machines.  To help us do that, we are going to leverage Docker Machine.  It's a tool that lets you install Docker Engine on virtual hosts, and manage the hosts with docker-machine commands. You can use Machine to create Docker hosts on your local Mac or Windows box, on your company network, in your data center, or on cloud providers like Azure, AWS, or DigitalOcean.  


#### Provision an AWS Docker Instance
Run the command below to create a Docker instance in AWS.  The various parameters associated with the AWS EC2 driver can be found [here](https://docs.docker.com/machine/drivers/aws/). 

```
docker-machine create --driver amazonec2 \
                      --amazonec2-access-key ********4321 \
                      --amazonec2-secret-key *********lkjhg \
                      --amazonec2-vpc-id vpc-abcd123 \
                      --amazonec2-zone b \
                      --amazonec2-subnet-id subnet-1234567 \
                      --amazonec2-instance-type m5.large \
                      --amazonec2-keypair-name mykey \
                      --amazonec2-ssh-keypath ~/.ssh/id_rsa hradocker01
```

#### List the VM and Get the IP Address
Use this command to list the machine and get the IP address. 

```
docker-machine ls
```
Here is example output from this command.

```
$ docker-machine ls
NAME             ACTIVE   DRIVER       STATE     URL                        SWARM   DOCKER     ERRORS
hradocker01      -        amazonec2    Running   tcp://3.89.92.200:2376             v19.03.2
```

#### Initialize the Swarm 

This machine will act as the manager, which executes management commands and authenticates workers to join the swarm.

You can send commands to the VM using `docker-machine ssh`. Instruct `hradocker01` to become a swarm manager with `docker swarm init --advertise-addr <hradocker01 ip>` and you’ll see output like this:
```
$ docker-machine ssh hradocker01 "docker swarm init --advertise-addr 3.89.92.200"
Swarm initialized: current node (q99**************bjj) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-***************************-********fny1g 3.89.92.200:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```

### Deploy the App to the Swarm Cluster
Configure a docker-machine shell to the swarm manager
