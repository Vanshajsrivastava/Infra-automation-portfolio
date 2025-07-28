# Terraform AWS VPC + EC2 Project

This project demonstrates how to automate AWS infrastructure using **Terraform**. It creates a VPC, subnet, Internet Gateway, and an EC2 instance with internet access.

## What This Project Does

* Creates a **VPC** with a custom CIDR block
* Sets up a **subnet** in the VPC
* Attaches an **Internet Gateway** for internet access
* Creates a **public route table** and associates it with the subnet
* Launches an **EC2 instance** inside the public subnet
* Outputs key information like instance ID, public/private IPs, and subnet ID

## Why It Matters

This setup simulates what real Cloud/DevOps Engineers do:

* Automating infrastructure with **Infrastructure as Code**
* Organizing resources into reusable, readable Terraform code
* Making EC2 publicly accessible with proper networking

---

## Folder Structure

```
Infra-automation-portfolio/
└── terraform-vpc-ec2/
    ├── main.tf              # Defines all AWS resources
    ├── provider.tf          # Configures the AWS provider
    ├── variables.tf         # Input variables used in the project
    ├── terraform.tfvars     # Values for the variables
    ├── outputs.tf           # Shows outputs like IPs after apply
    └── README.md            # Project documentation

## How To Use This

1. Clone the repo

```bash
git clone https://github.com/Vanshajsrivastava/Infra-automation-portfolio.git
cd Infra-automation-portfolio/terraform-vpc-ec2
```

2. Initialize Terraform

```bash
terraform init
```

3. Plan the deployment

```bash
terraform plan
```

4. Apply the deployment

```bash
terraform apply
```

5. View Outputs

```bash
terraform output
```

You will see:

* VPC ID
* Subnet ID
* EC2 instance ID
* Private and Public IPs

---

## Example Output

```bash
Outputs:

vpc_id = "vpc-0a12345..."
subnet_id = "subnet-0b67890..."
instance_id = "i-0123abc..."
instance_private_ip = "10.0.1.10"
instance_public_ip = "13.45.23.78"
```

## What You Have Learned

* How to create public infrastructure on AWS with Terraform
* How to expose an EC2 instance to the internet
* How to structure Terraform projects in a clean, professional way

## Next Steps (Optional Advanced Additions)

* Add a **security group** to allow SSH or HTTP
* Use **user\_data** to install software on EC2
* Break into **modules** for cleaner reuse
* Use **Terraform Cloud** or remote backends

End of README

