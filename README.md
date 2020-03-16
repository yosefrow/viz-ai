# Viz.Ai Demo (Secure web server)

## General Overview

It is important that you treat this as a project you'd be willing to run in a production environment, so we expect a high level of "completeness".
But like at day-to-day work, there is no "one right solution", and any of the numerous possible architectures is acceptable.

If you get stuck, or find that it takes too much of your time, you can wrap it up by documenting what you've accomplished vs. what was left,
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

## Deliverables

### GitHub repository Address

Repo: <https://github.com/yosefrow/viz-ai>

### Jenkins sign-in address + credentials

- Address: <http://108.128.231.83:8080>
- User: user
- Pass: abc123!@#

- Job: <http://108.128.231.83:8080/job/viz-ai_deploy-webapp>

### Webpage address (internal)

Address: <http://172.40.1.116/>

You must be connected to the VPN! See instructions in next step

### Instructions for installing the VPN client and connecting + credentials

- Visit Connect interface: <https://52.213.137.110:943/?src=connect>
- Login
  - User: webapp-user
  - Password: abc123!@#
- Download OpenVPN Connect for your device
- Click download link from "Available Connection Profiles:"
- Install OpenVPN Connect
- Run OpenVPN Connect
- From OpenVPN Connect
  - Menu > Import Profile > File
  - Drag and drop Connection profile file (`*.ovpn`) That you downloaded earlier
  - Enter Password and Connect

### Instructions for VPN Admin

- Visit Admin Interface: <https://52.213.137.110:943/admin>
- Login
  - User: global-admin
  - Password: abc123!@#

## Implementation Details

### Considerations

Should Jenkins and the VPN be on the same management server?

I decided against it, since those who have access to the Jenkins server via SSH or knowledge of the Jenkins Public IP, should not necessarily have such knowledge or access to the VPN, which allows access to sensitive internal servers.

How should management and orchestration be handled for the webserver?

Considering the requirement that the web server be in a private network, to me this meant that no other routes should be available to reach the web server except through the VPN server or within the aws VPC. This means the VPN must be setup first, so that we can orchestratrate the webserver without using the VPN server as a bastion.

How should instance orchestration happen in general?

In general we should orchestrate our servers with ansible. However, due to time limitations, I have not yet implemented this.

### VPC : Cloud environment

- Create project VPC 172.40.0.0/16
- Create Subnets
  - Private Subnet: 172.40.1.0/24
  - Public Subnet: 172.40.2.0/24
- Create Additional Interfaces
  - Internet Gateway
    - Attach Internet Gateway to VPC
  - Nat Gateway in Public Subnet (for Egress-Only Traffic)
- Create Route Tables
  - private-route -> Private Subnet
    - Add 0.0.0.0/0 -> NAT Gateway
  - public-route -> Public Subnet
    - Add 0.0.0.0/0 -> Internet Gateway

- Associate private subnet with private route
- Associate public subnet with public route

### EC2 : Cloud environment

- Generate SSH Key/Pair
- Create Security Groups
  - OpenVPN
    - 0.0.0.0/0 -> 22 (SSH)
    - 0.0.0.0/0 -> 943 (VPN Web GUI)
    - 0.0.0.0/0 -> 9443 (VPN TCP)
    - 0.0.0.0/0 -> 1194 (VPN UDP)
  - WebServer
    - 172.40.0.0/16 -> 22 (this rule won't do anything because we're in a private subnet. But we want to avoid warning)
    - OpenVPN Server ec2 -> 80 (web access through the VPN)
  - Jenkins
    - 0.0.0.0/0 -> 22 (SSH)
    - 0.0.0.0/0 -> 8080 (Jenkins HTTP)
    - 0.0.0.0/0 -> 8443 (Jenkins HTTPS)
- Create EC2 instances
    1. OpenVPN
       1. Ubuntu 18.04
       2. T2 micro
       3. project VPC
       4. protect against accidental termination
       5. public-subnet
       6. 10GB Disk
       7. ssh key/pair
    2. Jenkins
       1. Ubuntu 18.04
       2. T2 small
       3. project VPC
       4. protect against accidental termination
       5. public-subnet
       6. 10GB Disk
       7. ssh key/pair
    3. WebServer
       1. Ubuntu 18.04
       2. T2 micro
       3. project VPC
       4. protect against accidental termination
       5. private-subnet
       6. 10GB Disk
       7. ssh key/pair
- Allocate 2 Elastic IPS
  - Associate elastic IP to OpenVPN, Tag App: OpenVPN
  - Associate elastic IP to Jenkins, Tag App: Jenkins

#### Instance Types

Ideally we should plan and predict using the official reference

- OpenVPN: <https://openvpn.net/vpn-server-resources/openvpn-access-server-system-requirements/>
- Nginx: <https://www.nginx.com/resources/datasheets/nginx-plus-sizing-guide/>
- Jenkins: <https://jenkins.io/doc/book/hardware-recommendations/>

Type Reference:

- T2 Micro: { "vCpu": "1", "RAM-GiB": "1" }
- T2 Small: { "vCpu": "1", "RAM-GiB": "2" }

### Cloud Pricing

#### EC2 Instances

t2.micro = 2 * $0.0126 Per day
t2.small = 1 * $0.0250 Per day

<https://aws.amazon.com/ec2/pricing/on-demand/>

#### Elastic IPS

An Elastic IP address doesn't incur charges as long as the following conditions are true:

The Elastic IP address is associated with an EC2 instance.
The instance associated with the Elastic IP address is running.
The instance has only one Elastic IP address attached to it.

<https://aws.amazon.com/premiumsupport/knowledge-center/elastic-ip-charges/>

#### Disc Usage

General Purpose SSD (gp2) Volumes	$0.11 per GB-month of provisioned storage

`10GB * 3 * 0.11 = $3.30 per month`

<https://aws.amazon.com/ebs/pricing/>

### Provision Nodes

- Install Docker <https://docs.docker.com/install/linux/docker-ce/ubuntu/>
- Install Docker-Compose <https://docs.docker.com/compose/install/>
- `mkdir ~/repos && cd ~/repos`
- `git clone git@github.com:yosefrow/viz-ai.git`

### VPN server

OpenVPN is being used to restrict access to the web server

#### VPN Setup Process

`cd openvpn-as`
`./build.sh`


#### View logs and wait till started

`docker-compose logs -f openvpn-as`

```
openvpn-as    | [services.d] starting services
openvpn-as    | [services.d] done.

```

#### Visit the dashboard

e.g. https://<gui-public-host>:943/admin

#### Default credentials

- user: admin
- pass: password

#### Persistent Data

Persistent data is stored in the location defined in the variable '${OPENVPN_AS_DATA_DIR_EXTERNAL}' in '.env'

SQLite Databases are stored in `${OPENVPN_AS_DATA_DIR_EXTERNAL}/etc/db`

Ideally we should use mysql instead of sqlite3 dbs

See: <https://openvpn.net/vpn-server-resources/setting-up-an-openvpn-access-server-cluster/>

#### Change the public ip

1. https://<gui-public-host>:943/admin/network_settings
  - Hostname or IP Address: vpn-public-ip-or-host
2. Click Save Settings
3. Click Update Running Server

#### Disable internet hijacking

In our use case we don't want all internet traffic routing through the VPN, so disable it.

1. https://<gui-public-host>:943/admin/vpn_settings
  - Should client Internet traffic be routed through the VPN?: No
2. Click Save Settings
3. Click Update Running Server

#### Modify Routing

- https://<gui-public-host>:943/admin/vpn_settings
- Should VPN clients have access to private subnets (non-public networks on the server side)?No (avoid global routing)

#### Create Groups

https://<gui-public-host>:943/admin/group_permissions

- WebApp Users:
  - More Settings:
    - Use Access Control: Yes 
    - Allow Access To networks and services: 
      - <private-server-ip>/32:tcp/80
    - Allow Access To groups: None
- Global Admins:
  - Admin: v
  - More Settings:
    - Use Access Control: Yes 
    - Allow Access To networks and services: 
      - <private-server-ip>/32:tcp/80
      - <private-server-ip>/32:tcp/22
    - Allow Access To groups: None

#### Create Users

https://<gui-public-host>:943/admin/user_permissions

- webapp-user: "Group: WebApp Users"
  - More Settings: Password: abc123!@#
- global-admin: "Group: Global Admins"
  - More Settings: Password: abc123!@#


#### Test Connection

- https://<gui-public-host>:943/?src=connect

#### VPN References

<https://github.com/linuxserver/docker-openvpn-as>

### Web Server

The web server hosts our example corporate website based on code that exists in our repo. 
Currently It uses nginx to server a basic website

#### Web Server Setup Process

`cd nginx`
`./build.sh`

#### Provision Jenkins User

`sudo adduser jenkins`
`sudo adduser jenkins docker`
`sudo -sHu jenkins`
`ssh-keygen`
`cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys`

### Jenkins server

Jenkins is being used to deploy the code to the web server

#### Jenkins Setup Process

`cd jenkins`
`./build.sh`

#### Create Jenkins Pipeline job

- General
  - GitHub Project:  `https://github.com/<github-user>/<github-repo>/settings/hooks`
- Build Triggers
  - GitHub hook trigger for GITScm polling: v
- Pipeline
  - Pipeline script from SCM
    - SCM: Git
    - Repository URL: `https://github.com/<github-user>/<github-repo>/settings/hooks`
  - Script Path: Jenkinsfile

#### Create Jenkins SSH Credentials

- `http://<jenkins-server-url>:8080/credentials/store/system/domain/_/newCredentials`
- Kind: SSH Username with private key
- ID: jenkins-viz-ai
- Description: Jenkins Viz.ai SSH
- Username: jenkins
- Private Key > Enter Directly > `ssh webserver 'cat ~jenkins/.ssh/id_rsa'`

#### Create Jenkins SSH Host Credentials

- `http://<jenkins-server-url>:8080/credentials/store/system/domain/_/newCredentials`
- Kind: Secret Text
- Secret: <jenkins-host>
- ID: jenkins-viz-ai-ssh-host
- Description: Jenkins Viz.ai SSH Host

#### Jenkins References

<https://raw.githubusercontent.com/bitnami/bitnami-docker-jenkins/master/docker-compose.yml/>
<https://hub.docker.com/r/bitnami/jenkins/>

### GitHub CI/CD

The github repo is configured to automatically trigger the jenkins webhook when we push code.

#### Create GitHub WebHook

1. `https://github.com/<github-user>/<github-repo>/settings/hooks`
2. Add Webhook
3. e.g. `http://<jenkins-server-url>:8080/github-webhook/`

