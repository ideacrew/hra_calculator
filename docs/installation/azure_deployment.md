---
layout: page
title: Azure Deployment
permalink: /hra_tool/installation/azure_deployment/
parent: Installation
grand_parent: HRA Tool
nav_order: 3
---

## Azure Deployment
For cloud and data center deployments, Docker Swarm will be used.  Swarm is a Docker-native clustering system.  It turns a pool of Docker hosts into a single, virtual host using an API proxy system.  The instructions below describe how to provision a single node swarm.  Instructions on how to add nodes to the swarm cluster can be found [here](https://docs.docker.com/v17.09/get-started/part4/#set-up-your-swarm).

### Setting Up Your Swarm
In order to deploy to a Docker swarm, you have to provision one or more physical or virtual machines.  To help us do that, we are going to leverage Docker Machine.  It's a tool that lets you install Docker Engine on virtual hosts, and manage the hosts with docker-machine commands. You can use Machine to create Docker hosts on your local Mac or Windows box, on your company network, in your data center, or on cloud providers like Azure, AWS, or DigitalOcean.  


### Provision an Azure Docker Instance
Run the command below to create a Docker instance in Azure.  The various parameters associated with the Azure driver can be found [here](https://docs.docker.com/machine/drivers/azure/). 

```                     
docker-machine create --driver azure \
                      --azure-size Standard_D2a_v3
                      --azure-subscription-id ********4321 hradocker01
Running pre-create checks...
Microsoft Azure: To sign in, use a web browser to open the page https://aka.ms/devicelogin.
Enter the code [...] to authenticate.
```

### List the VM and Get the IP Address
Use this command to list the machine and get the IP address. 

```
docker-machine ls
```
Here is example output from this command.

```
$ docker-machine ls
NAME             ACTIVE   DRIVER       STATE     URL                        SWARM   DOCKER     ERRORS
hradocker01      -        azure        Running   tcp://3.94.87.202:2376             v19.03.2
```

### Initialize the Swarm 

This machine will act as the manager, which executes management commands and authenticates workers to join the swarm.

You can send commands to the VM using `docker-machine ssh`. Instruct `hradocker01` to become a swarm manager with `docker swarm init --advertise-addr <hradocker01 ip>` and you’ll see output like this:
```
$ docker-machine ssh hradocker01 "docker swarm init --advertise-addr 3.94.87.20"
Swarm initialized: current node (q99**************bjj) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-***************************-********fny1g 3.94.87.20:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```

### Deploy the App to the Swarm Cluster
Configure a docker-machine shell to the swarm manager
