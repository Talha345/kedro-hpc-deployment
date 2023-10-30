# Deployment of Kedro-based Machine Learning Projects in HPC Environment

## Implementation Guide

This section outlines the essential steps required to harness the power of this solution for deploying Kedro-based machine learning projects in an HPC environment seamlessly. The solution implementation comprises a collection of scripts and files meticulously designed to streamline the deployment process.

Below, we introduce the key components of this toolkit:

- **Dockerfile**: This file serves as the foundation for your Kedro project within a Docker container, enabling easy encapsulation of your project’s dependencies and configurations.
- **.dockerignore**: Ignores specific directories and files within your Kedro project during containerization, optimizing resource usage and maintaining a clean Docker image.
- **.gitlab-ci.yml**: This pivotal file orchestrates the entire CI/CD pipeline, automating various stages of deployment and ensuring a smooth, error-free workflow.
- **build-singularity-image.sh**: A critical script utilized in the deployment phase of the CI/CD pipeline. It clones your Git repository and constructs a Singularity image from the Docker image on the HPC server, facilitating seamless containerization.
- **submit-batch-job.sh**: In the post-deployment phase of the CI/CD pipeline, this script comes into play. It enables the submission of a batch job to the SLURM scheduler, initiating the execution of your Kedro pipeline on the HPC cluster.
- **batch-job-file.sh**: The batch job script submitted to the SLURM scheduler for the execution of your Kedro pipeline. This script ensures efficient resource allocation and job execution.

### Usage Instructions

Now, let’s delve into the step-by-step process of using these components to deploy your Kedro project onto an HPC environment.

**Pre-requisites**

Before diving into the deployment process, ensure the following pre-requisites are met:

1. **Kedro Project and Git Repository**: You should have a functional Kedro project already set up, complete with a Git repository. It’s essential to emphasize that this solution is specifically tailored to work with GitLab CI/CD. Therefore, ensure that your Kedro project is version-controlled on GitLab to leverage the full capabilities of this deployment approach.

2. **Container Registry**: Configure a container registry of your choice. Options include DockerHub, AWS Elastic Container Registry (ECR), Azure Container Registry, GitHub Container Registry, or Google Container Registry. This registry will serve as the storage location for your Docker images, allowing for efficient distribution and deployment.

3. **SSH Access to Target HPC System**: Ensure that you have SSH access to the intended HPC system. This access is vital for executing various deployment scripts and managing your project within the HPC environment.

4. **Workspace Directory**: Create a dedicated workspace directory on the HPC system where your project will be deployed. This directory will serve as the working environment for your project on the HPC infrastructure.

5. **SSH Key Pair Creation**: To enable the CI/CD pipeline to SSH into the HPC system, you need to generate a new SSH key pair. Add the public key to the list of authorized hosts on the HPC system. Be sure to save the private key securely, as it will be required for later steps in the deployment process.

6. **CI/CD Runners in GitLab**: Set up CI/CD runners in GitLab. These runners can be either shared or self-hosted, depending on your requirements. It’s imperative that these runners have connectivity to the HPC system you intend to deploy on, as they play a pivotal role in automating the deployment process.

7. **GitLab Project Access Token**: In order to allow the HPC system to clone your GitLab repository, you will need to create a Project Access Token in your GitLab project settings. In order to do so, follow these steps:

   i. Access your GitLab repository and navigate to the following location: `Settings → Access Tokens`.

   ii. Create a new Personal Access Token. Set the role as Reporter, and assign only read permissions to the token.

   iii. After creating the token, go to your local system, clone the GitLab repository using the created token with the following command (replace placeholders with your specific information):
   
   ```shell
   git clone https://<gitlab-username>:<access-token>@<repo-url>.git
   ```
   
    **Note**: This step is for testing purposes to ensure that the repository can be cloned successfully using the clone URL. If successful, save the repository clone URL for later use.

**Setup**

1. Begin by downloading the toolkit, which is provided as a zip file. Once downloaded, extract the toolkit files and place them in the root directory of your project repository.

2. Access your GitLab repository and navigate to the following location: `Settings → CI/CD → Variables`. In this section, you will define nine essential variables that are required for the deployment process. Set each of these variables as follows:

   i. **CONTAINER_REGISTRY_HOST**: Specify the host address of your configured container registry. For example, for Dockerhub, this will be `docker.io`.

   ii. **CONTAINER_REGISTRY_REPOSITORY**: Provide the complete name of the repository within your configured container registry where the Docker images will be stored. For example, `max345/kedro-image-classification`.

   iii. **CONTAINER_REGISTRY_USERNAME**: Enter the username associated with your container registry for HTTPS access.

   iv. **CONTAINER_REGISTRY_PASSWORD**: Input the password or access token associated with your container registry for HTTPS access.

   v. **HPC_ADDRESS**: Provide the IP address or hostname of the target HPC system where you intend to deploy your project.

   vi. **SSH_USER**: Specify the username that has SSH access to the HPC system. This user will be responsible for executing deployment tasks on the HPC environment.

   Note: If your HPC SSH address is in the format `deploy@target-hpc.com`, your `SSH_USER` should be set as `deploy`, and the `HPC_ADDRESS` should be set as `target-hpc.com`.

   vii. **WORKSPACE_DIR**: This should be set as the absolute path of the workspace directory created earlier on the HPC system. You can find this path by navigating to the directory within the HPC system and running the `pwd` command.

   viii. **SSH_PRIVATE_KEY**: This should be set as the private key of the SSH key pair generated earlier to allow the HPC system to clone the git repository.

   ix. **REPO_CLONE_URL**: This should be set as the Gitlab repository clone URL which was tested and saved earlier. It would be in the format:
   
   ```shell
   https://<gitlab-username>:<access-token>@<repo-url>.git
   ```
3. **Verify Dockerfile**: Verify that the Dockerfile is working correctly in the repository by building the Docker image locally. Make any necessary changes to the Dockerfile to ensure it meets your project’s specific requirements.

4. **Edit batch-job-file.sh**: If required, edit the `batch-job-file.sh` to update the necessary resources needed for your project’s requirements.

5. **Commit to Gitlab Repository**: Finally, commit the code to the Gitlab repository. The CI/CD pipeline will be triggered automatically. Once the build stage is completed, you can trigger the subsequent stages manually when required. These stages can also be configured to run automatically one after the other by removing the `manual: true` configuration option in the respective stages in the `.gitlab-ci.yml` file.



   
