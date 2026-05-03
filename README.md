# React-APP test

ARCHITECTURE:

                                    +-------------------+
                                    |  Git Repository   |
                                    | (React Code)      |
                                    +---------+---------+
                                            |
                                            v
                                    +-------------------+
                                    |   Jenkins Server  |
                                    |  CI/CD Pipeline   |
                                    +---------+---------+
                                            |
                                    Build Docker Image
                                            |
                                            v
                                    +-------------------+
                                    |    Docker Hub     |
                                    | (Image Registry)  |
                                    +---------+---------+
                                            |
                                    Pull Docker Image
                                            |
                                            v
                                    +-------------------+
                                    | Application Server|
                                    | (Docker Container)|
                                    |  React App Runs   |
                                    +---------+---------+
                                            |
                                            v
                                    +-------------------+
                                    |   End Users       |
                                    | (Browser Access)   |
                                    +-------------------+

                                            |
                                            v
                                    +-------------------+
                                    |   Uptime Kuma     |
                                    |  Monitoring Tool  |
                                    | (Checks App URL)  |
                                    +-------------------+

Project Deployment & CI/CD Pipeline

Overview

This project demonstrates a complete CI/CD workflow for a React application using Jenkins, Docker, Docker Hub, and Uptime Kuma for monitoring.

What I Have Done:

1. Cloned the Repository
Cloned the application repository to set up the local development and deployment environment.

2. Set Up Jenkins Server
Configured a Jenkins server to automate the build and deployment process.
    Installed and configured Jenkins
    Set up required plugins (Git, Docker, Pipeline, etc.)
    Created a CI/CD pipeline job for the application

3. Dockerized the React Application
Containerized the React application using Docker.
    Created a Dockerfile for the React app
    Built Docker image using Jenkins pipeline
    Automated image build process


4. Pushed Docker Image to Docker Hub
After building the image, it was pushed to Docker Hub for centralized storage and distribution.

5. Pulled Image on Application Server
On the application server, the Docker image was pulled and run.


6. Setup Monitoring with Uptime Kuma
Configured Uptime Kuma to monitor application uptime and availability.
    Installed Uptime Kuma
    Added application URL as a monitoring endpoint
    Configured alerts for downtime notifications

This ensures continuous monitoring of application health and availability.
----------------------------------------------------------------------------------------------------
Tech Stack
    React.js
    Jenkins (CI/CD)
    Docker
    Docker Hub
    Uptime Kuma
    Linux Server
----------------------------------------------------------------------------------------------------

Jenkins Server: 
----------------------------------
Public IP: 52.207.219.164
Private IP: 172.31.94.40
Instance ID: i-07b0b303311d7140c
----------------------------------

App Server:
----------------------------------
Public IP: 13.222.194.219
Private IP: 172.31.45.70
Instance ID: i-0f128702d10fd68af
----------------------------------


----------------------------------------------------------------------------------------------
Monitoring Setup:
----------------------------------------------------------------------------------------------

After Jenkins deployment,
Step1: Log Into the EC2 Server (Modify SG inbound with 3001 port for Uptime Kuma dashboard)
----------------------------------------------------------------------------------------------
Step2: Install and Start Uptime Kuma
    sudo docker volume create uptime-kuma
    sudo docker run -d \
    --name uptime-kuma \
    -p 3001:3001 \
    -v uptime-kuma:/app/data \
    --restart=always \
    louislam/uptime-kuma:latest   (Start automatically whenever the EC2 instance reboots)
----------------------------------------------------------------------------------------------
Step3: Access dashboard
    Open: http://<EC2-PUBLIC-IP>:3001
----------------------------------------------------------------------------------------------    
Step4: Add Your Application Monitor
    Monitor Type: HTTP(s)
    Name: React App
    URL: http://<EC2-PUBLIC-IP>
    Heartbeat Interval: 60 seconds     (it will continuously check your app)
----------------------------------------------------------------------------------------------    
Step5: Configure Notifications 
    Add notification channel
        SMTP(Email)  (Set alerts to trigger when the monitor status changes to DOWN)   
----------------------------------------------------------------------------------------------      
                    ARCHITECTURE
                            EC2 Instance
                    ├── react-app container       ← Updated by Jenkins
                    └── uptime-kuma container     ← Runs continuously    
----------------------------------------------------------------------------------------------                    
    
