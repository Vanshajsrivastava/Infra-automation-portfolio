
# AWS CloudWatch Monitoring & Alerting with Terraform

This project demonstrates proactive cloud monitoring by deploying an AWS environment with Terraform, running a CPU stress test on an EC2 instance, and sending automated email alerts via SNS when CPU usage exceeds a set threshold.


## Project Overview

Using Terraform, this project:

1. Creates a custom VPC with a public subnet.
2. Launches a t2.micro EC2 instance in that subnet.
3. Simulates high CPU usage to trigger alerts.
4. Sets up a CloudWatch alarm for CPU > 80% for 5 minutes.
5. Uses SNS to send email alerts when the alarm triggers.


## Project Structure

```bash
cloudwatch-monitoring/
├── main.tf         # Terraform config for VPC, EC2, CloudWatch, SNS
├── variables.tf    # Variables (email, thresholds, region, etc.)
├── outputs.tf      # Outputs for important resource IDs and ARNs
└── README.md       # Documentation
```

---

## Tools & AWS Services Used

* Terraform – Infrastructure as Code (IaC)
* AWS VPC – Networking
* AWS EC2 – Compute instance
* AWS CloudWatch – Monitoring & alarms
* AWS SNS – Notifications

---

## How to Deploy

### 1. Clone the repo

```bash
git clone https://github.com/<your-repo>/cloudwatch-monitoring.git
cd cloudwatch-monitoring
```

### 2. Update variables

Edit `variables.tf` and set:

* Your AWS region
* Your email for SNS alerts

### 3. Deploy with Terraform

```bash
terraform init
terraform apply
```

Type `yes` to confirm.

### 4. Confirm SNS Subscription

Check your email and confirm the subscription to receive alerts.

### 5. Wait for Alarm

The EC2 instance runs a CPU stress test after launch.
If CPU usage > 80% for 5 minutes:

* CloudWatch triggers the alarm.
* SNS sends an email alert.

### 6. Destroy resources when done

```bash
terraform destroy
```

---

## Expected Results

After deployment:

* You will have a running EC2 instance in a new VPC.
* CloudWatch monitors CPU usage in real time.
* If CPU > 80% for 5 minutes, you will receive an email alert.
* A CloudWatch dashboard will be available to view metrics.

---

## Learning Outcomes

By completing this project, you will demonstrate:

* AWS networking setup with Terraform.
* CloudWatch alarm configuration.
* Automated incident notifications with SNS.
* End-to-end AWS infrastructure automation.

---

