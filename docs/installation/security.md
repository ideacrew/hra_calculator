---
layout: page
title: Security
permalink: /hra_tool/installation/security/
parent: Installation
grand_parent: HRA Tool
nav_order: 5
---

## Security
Using the `docker-machine create` command includes a default set of security rules for deployments to AWS and Azure.  In AWS, an existing security group can be used to restrict IP addresses and ports.  If a security group is not specified, a security group is created that only opens SSH and Docker ports.  Azure works in a similar fashion.  All of the provisioned machine ports are inaccessible by default, with the exception of the SSH and Docker ports.  Both docker-machine drivers provide the ability to open additional ports at launch time using the `--amazonec2-open-port` and `--azure-open-port` parameters respectively.

In addition to the physical protection of the machines, the `docker-machine create` command provides the ability to specify a SSH key to protect access to the machine.  On initial startup, this key is the only way to log into the server.

### AWS Security and Security Groups
If a security group is not specified when running the `docker-machine create` command, then a security group is created and associated to the host. This security group has the following ports opened inbound:

- **ssh** (22/tcp)
- **docker** (2376/tcp)
- **swarm** (3376/tcp), only if the node is a swarm master

If you specify a security group yourself using the `--amazonec2-security-group` flag, the above ports are checked and opened and the security group is modified. If you want more ports to be opened such as application-specific ports, use the `--amazonec2-open-port` or open the AWS console and modify the security group manually.

### Azure Security and Network Security Groups
Each machine is created with a public dynamic IP address for external connectivity. All its ports (except Docker and SSH) are closed by default. You can use `--azure-open-port` argument to specify multiple port numbers to be accessible from Internet.

Once the machine is created, you can modify [Network Security Group](https://azure.microsoft.com/en-us/documentation/articles/virtual-networks-nsg/) rules and open ports of the machine from the [Azure Portal](https://portal.azure.com/).

### Certificates
Traffic to the application should be protected using HTTPS (TLS) and thus SSL certificates should be purchased or otherwise obtained (e.g. via Let's Encrypt).  Using the deployment instructions provided, certificates are securely copied to the server at deployment time and thus should never reside in a code repository.  The assumption is that the SBEs will be reponsible for procuring their own certificates.
