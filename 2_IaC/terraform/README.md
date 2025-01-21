
# Terraform Project: AWS Infrastructure Setup

## Overview
This project demonstrates the provisioning of a secure, scalable, and highly available infrastructure on AWS using **Terraform**. It adheres to industry best practices, showcases modular design principles, and emphasizes maintainability and security. The infrastructure setup includes:

1. **VPC**: Custom-configured Virtual Private Cloud to isolate the network environment.
2. **Bastion Host**: Secure SSH gateway for accessing internal resources.
3. **Elastic Load Balancer (ELB)**: Routes traffic to web servers, ensuring scalability and availability.
4. **Web Servers**: Private EC2 instances hosting the application.
5. **RDS (MySQL)**: Managed database with high availability in private subnets.
6. **NAT Gateway**: Enables secure outbound internet access for private subnets.

This document outlines the project structure, deployment steps, and key considerations for best practices, tailored for demonstrating expertise in a professional setting.

---

## Directory Structure

The project is modular, with reusable components for scalability and clarity:

```
terraform-project/
├── main.tf           # Root configuration
├── variables.tf      # Root-level variables
├── outputs.tf        # Root-level outputs
├── modules/          # Modular resources
│   ├── vpc/          # VPC module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── bastion/      # Bastion host module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── web_server/   # Web server module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── rds/          # RDS (MySQL) module
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
```

---

## Features

### Infrastructure Components

1. **VPC**:
   - Custom CIDR block for IP address management.
   - Public and private subnets for logical separation.
   - Internet Gateway for public subnet connectivity.
   - Route Tables for traffic control.

2. **Bastion Host**:
   - Provides secure SSH access to internal resources.
   - Limited access via Security Groups to a specific range of IPs.

3. **Elastic Load Balancer**:
   - Distributes incoming traffic (port 443) to web servers.
   - SSL termination enabled via ACM for enhanced security.

4. **Web Servers**:
   - Hosted on EC2 instances in private subnets.
   - Security Groups configured to allow traffic only from the ELB.

5. **RDS (MySQL)**:
   - Multi-AZ deployment ensures high availability.
   - Placed in private subnets for enhanced security.

6. **NAT Gateway**:
   - Provides secure internet access for resources in private subnets.

---

## Deployment Steps

### Prerequisites
1. **Terraform**: Install Terraform [here](https://www.terraform.io/downloads).
2. **AWS CLI**: Install and configure with your credentials.
3. **IAM User**: Ensure the IAM user has permissions for VPC, EC2, ELB, RDS, and related services.

### Step-by-Step Deployment

1. **Clone the Repository**:
   ```bash
   git clone <repository_url>
   cd terraform-project/
   ```

2. **Initialize Terraform**:
   Download the necessary providers and modules:
   ```bash
   terraform init
   ```

3. **Customize Variables**:
   Edit `variables.tf` in the root and module directories to match your requirements (e.g., region, CIDR blocks, instance types).

4. **Validate Configuration**:
   Ensure the configuration is correct:
   ```bash
   terraform validate
   ```

5. **Plan the Deployment**:
   Generate and review the execution plan:
   ```bash
   terraform plan
   ```

6. **Apply the Configuration**:
   Deploy the infrastructure:
   ```bash
   terraform apply
   ```
   Confirm the action when prompted.

7. **Access Outputs**:
   Retrieve key information like ELB URL and Bastion Host IP:
   ```bash
   terraform output
   ```

---

## Security Best Practices

1. **State File Management**:
   - Use remote backends (e.g., S3 with encryption and versioning) to store `terraform.tfstate` securely.
   - Enable state locking to prevent conflicts.

2. **Secrets Management**:
   - Avoid hardcoding sensitive data in Terraform files.
   - Use AWS Secrets Manager or HashiCorp Vault for secure storage.

3. **IAM Policies**:
   - Follow the principle of least privilege for Terraform IAM roles.
   - Assign roles to EC2 instances via Instance Profiles instead of embedding credentials.

4. **Security Groups**:
   - Restrict SSH access (port 22) to trusted IPs only.
   - Allow only necessary inbound/outbound traffic to minimize exposure.

5. **Encryption**:
   - Enable encryption for RDS and its backups.
   - Use ACM for SSL certificates.

6. **Monitoring and Logging**:
   - Enable VPC Flow Logs for traffic analysis.
   - Use CloudWatch for monitoring resource health and setting alerts.

---

## Maintenance and Updates

1. **Modular Design**:
   - Modify individual modules independently without impacting the entire infrastructure.
   - Reuse modules across multiple projects to save time and ensure consistency.

2. **State Management**:
   - Use `terraform refresh` to sync state with the real infrastructure.
   - Backup state files regularly.

3. **Updates**:
   - Always run `terraform plan` before applying changes to understand the impact.

4. **Scaling**:
   - Adjust Auto Scaling Groups (ASGs) for web servers as application demand increases.

---

## How to Destroy Resources

To tear down the infrastructure, run:

```bash
terraform destroy
```

Confirm the action when prompted. This will remove all resources created by Terraform.

---

## Notes

- Ensure AWS resource limits (e.g., EC2 instances, VPCs) in the chosen region are sufficient.
- Regularly monitor costs using the AWS Billing Console to stay within budget.

---

## Contact
For any issues or questions, please reach out via email or the provided communication channel.

Happy Terraforming!
