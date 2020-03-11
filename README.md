# Viz.Ai Demo (Secure web server)

## General Overview

It is important that you treat this as a project you'd be willing to run in a production environment, so we expect a high level of "completeness".
But like at day-to-day work, there is no "one right solution", and any of the numerous possible architectures is acceptable.

If you get stuck, or find that it takes too much of your time, you can wrap it up by documenting what you’ve accomplished vs. what was left, 
and note how you would tackle everything not yet implemented\working properly.

Please note that the account is limited to the Ireland region only.

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
