# Viz.Ai Demo (Secure web server)

## General Overview

It is important that you treat this as a project you'd be willing to run in a production environment, so we expect a high level of "completeness".
But like at day-to-day work, there is no "one right solution", and any of the numerous possible architectures is acceptable.

If you get stuck, or find that it takes too much of your time, you can wrap it up by documenting what you’ve accomplished vs. what was left,
and note how you would tackle everything not yet implemented\working properly.

*Please note that the account is limited to the Ireland region only.*

## Project description

Implement an internal corporate web server which
    - can be as simple as a static "Hello World" webpage
    - is located in a private subnet
    - is accessible only through a VPN (to a few corporate offices)

Host the code of the webpage in a GitHub repository and
    - for every commit to the "master" branch, automatically deploy the code to the web server
    - deploy the code to the web server using Jenkins

Implement a way to control who can
    - access the web server instance
    - add or revoke access to the web server instance

Set access control so that
    - *you and I* can access the web server instance
    - *only you* can add or revoke access to the web server instance

The required deliverables are:
    - GitHub repository address
    - Jenkins sign-in address + credentials
    - Webpage address
    - Instructions for installing the VPN client and connecting + credentials

All information and instructions should be in the README.md file of the GitHub repository

## Implementation Details

### Considerations

I considered whether to put Jenkins and the VPN on the same management server but decided against it. The reasoning is that since those who have access to the Jenkins server via SSH or knowledge of the Jenkins Public IP, should not necessarily have such knowledge or access to the VPN, which allows access to sensitive internal servers.

I considered how management and orchestration would happen for the web server, given the requirement that it be in a private subnet and thought about using a public network interface with a strict security group for SSH and a private network for VPN -> Webserver traffic. However, considering the requirement that the web server be in a private network, to me this meant that no other network routes should be available to reach the web server except through the VPN server.

Therefore, SSH to the web server must occur from either inside the VPN, or from the VPN server itself.

### VPC : Cloud environment

- Create project VPC 172.40.0.0/16
- Create Internet Gateway
- Attach Internet Gateway to VPC
- Create Route Tables
  - private-route
  - public-route
    - Add 0.0.0.0/0 -> Internet Gateway
- Create Subnets
  - Private Subnet: 172.40.1.0/24
  - Public Subnet: 172.40.2.0/24
- Associate private subnet with private route
- Associate public subnet with public route

### EC2 : Cloud environment

- Generate SSH Key/Pair
- Create Security Groups
  - OpenVPN
    - 0.0.0.0/0 -> 22 (SSH)
    - 0.0.0.0/0 -> 443 (VPN)
    - 0.0.0.0/0 -> 943 (Web Interface)
  - WebServer
    - 172.40.0.0/16 -> 22 (this rule won't do anything because we're in a private subnet. But we want to avoid warning)
    - 172.40.0.0/16 -> 80 (web access through the VPN)
  - Jenkins
    - 0.0.0.0/0 -> 8080 ()
- Create EC2 instances
    1. OpenVPN
       1. Ubuntu 18.04
       2. T2 medium
          1. { "vCpu": "2", "RAM-GiB": "4", "On-Demand-Price-Hr: $0.0464" }
       3. project VPC
       4. protect against accidental termination
       5. public-subnet
       6. 10GB Disk
       7. ssh key/pair
    2. Jenkins
       1. Ubuntu 18.04
       2. T2 medium
          1. { "vCpu": "2", "RAM-GiB": "4", "On-Demand-Price-Hr: $0.0464" }
       3. project VPC
       4. protect against accidental termination
       5. public-subnet
       6. 10GB Disk
       7. ssh key/pair
    3. WebServer
       1. Ubuntu 18.04
       2. T2 medium
          1. { "vCpu": "2", "RAM-GiB": "4", "On-Demand-Price-Hr: $0.0464" }
       3. project VPC
       4. protect against accidental termination
       5. private-subnet
       6. 10GB Disk
       7. ssh key/pair
- Allocate 2 Elastic IPS
  - Associate elastic IP to OpenVPN, Tag App: OpenVPN
  - Associate elastic IP to Jenkins, Tag App: Jenkins

### Cloud Cost

#### EC2 Instances

3 * 1.1136 USD Per day = 3.3408 USD per day

#### Elastic IPS

An Elastic IP address doesn’t incur charges as long as the following conditions are true:

The Elastic IP address is associated with an EC2 instance.
The instance associated with the Elastic IP address is running.
The instance has only one Elastic IP address attached to it.

### Web Server

The web server hosts our example corporate website based on code that exists in our repo

#### Web Server Instance Details

Due to the currently unknown nature of usage, we are going with medium sized instance t2.medium
However, Ideally, we should plan and predict using the official reference
<https://openvpn.net/vpn-server-resources/openvpn-access-server-system-requirements/>

### Jenkins server

Jenkins is being used to deploy the code to the web server

#### Jenkins Instance Details

Due to the currently unknown nature of usage, we are going with medium sized instance t2.medium
However, Ideally, we should plan and predict using the official reference
<https://openvpn.net/vpn-server-resources/openvpn-access-server-system-requirements/>

#### Jenkins References

<https://raw.githubusercontent.com/bitnami/bitnami-docker-jenkins/master/docker-compose.yml/>
<https://hub.docker.com/r/bitnami/jenkins/>

### VPN server

OpenVPN is being used to restrict access to the web server

#### VPN Instance Details

Due to the currently unknown nature of usage, we are going with medium sized instance t2.medium
However, Ideally, we should plan and predict using the official reference 
<https://openvpn.net/vpn-server-resources/openvpn-access-server-system-requirements/>

#### VPN References

<https://github.com/kylemanna/docker-openvpn/blob/master/docs/docker-compose.md>

### GitHub CI/CD
