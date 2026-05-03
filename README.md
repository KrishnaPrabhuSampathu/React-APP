# React-APP

Jenkins Server: 
----------------------------------
Public IP: 52.207.219.164
Private IP: 172.31.94.40
Instance ID: i-07b0b303311d7140c
----------------------------------












----------------------------------------------------------------------------------------------
Monitoring:
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
    
