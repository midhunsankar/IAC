
# Introduction
This repository contains my training resources for preparing for the Azure certification. It includes hands-on projects that demonstrate the use of Azure services and tools to build and deploy cloud-based solutions.

## Projects Overview
The following projects are part of this repository:

### Project 1: Container App
This project demonstrates the deployment of a containerized .NET Core application using Terraform. The Terraform will exec following steps:
- Build a Docker image of a sample .NET Core application.
- Push the Docker image to an Azure Container Registry.
- Deploy the containerized application.

### Project 2: Front Door Implementation
This project focuses on implementing Azure Front Door to enhance application delivery and security. The Terraform will exec following steps:
- Create an Azure Front Door profile using Terraform.
- Setting up routing rules and backend pools for efficient traffic management.

Additional steps you have to perform.
- Configure a custom domain for an Azure B2C workflow, which includes domain verification.
- Google custom domain verification azure b2c.

### Project 3: Container Instance with cosmos db backend
The project deploys a sample website written in GoLang and React to a conatiner instance. The backend database of this project is cosmos db.The Terraform will exec following steps:
- Build a Docker image of a sample .NET Core application.
- Push the Docker image to an Azure Container Registry.
- Deploy the containerized application to an Azure Container Instance.
- Create a cosmos db.

## Prerequisites
To work with these projects, ensure you have the following:
- An active Azure subscription.
- Terraform installed on your local machine.
- Basic knowledge of Azure services and Terraform scripting.

## Getting Started
1. Clone this repository to your local machine:
    ```bash
    git clone https://github.com/midhunsankar/IAC.git
    ```
2. Navigate to the project directory:
    ```bash
    cd az400
    ```
3. Follow the instructions in each project folder to deploy the resources.

## Contributing
Contributions are welcome! If you have suggestions or improvements, feel free to open an issue or submit a pull request.

## License
This repository is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

