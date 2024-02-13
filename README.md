# gcloud-tf
Repo to house terraform resources for Google Cloud related infrastructure

## Overview
This repository contains Terraform code and configuration files for provisioning and managing infrastructure on Google Cloud Platform (GCP). Using Infrastructure as Code (IaC) principles, you can automate the deployment of GCP resources such as virtual machines, networks, storage buckets, databases, and more.

## Table of Contents
- [Getting Started](#getting-started)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Getting Started
To get started with this project, clone the repository to your local machine:

```
git clone https://github.com/lukedappleton/gcloud-tf.git
```

## Prerequisites
Before using this Terraform code, make sure you have the following prerequisites installed and configured:
- Terraform - Terraform is used to provision and manage GCP resources.
- Google Cloud SDK - The Google Cloud SDK provides the `gcloud` command-line tool for managing GCP resources.
- Google Cloud Platform Account - You need a GCP account to create and manage resources.
- Service Account Key - Create a service account key with appropriate permissions to interact with GCP resources.
- Billing Account - Enable billing for your GCP project.

## Installation
1. Clone the repository to your local machine.
2. Navigate to the project directory.
3. Initialize Terraform:

```
terraform init
```

## Usage
1. Customize the Terraform configuration files (`*.tf`) according to your infrastructure requirements.
2. Review and validate the changes using:

```
terraform plan
```

3. Apply the changes to provision resources:

```
terraform apply
```

4. To tear down the provisioned infrastructure, use:

```
terraform destroy
```

## Contributing
Contributions are welcome! If you have suggestions, feature requests, or find any issues, please open an issue or a pull request.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
