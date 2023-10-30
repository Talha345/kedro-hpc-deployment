#!/bin/sh

set -e

# This script will SSH into the HPC, check if the workspace directory exists, if yes it will clone the latest git repository
# and build the singularity image from the docker image.

ssh -T "$SSH_USER"@"$HPC_ADDRESS" /bin/bash <<EOF

  # Move to the target directory if it exists
  if [ -d $WORKSPACE_DIR ]; then
    cd $WORKSPACE_DIR
    echo "Workspace directory exists. Current directory: \$(pwd)"

    # Clone the latest git repository
    repository_name=$(basename "$REPO_CLONE_URL" .git)
    rm -rf \$repository_name
    git clone $REPO_CLONE_URL
    echo "Repository cloned and saved to: \$(pwd)/\$repository_name"

    # Build a singularity image and store it in the set directory
    singularity_image_directory=singularity-images
    rm -rf "\$singularity_image_directory/\$repository_name.sif"

    # If the directory does not exist, create it
    if [ ! -d "\$singularity_image_directory" ]; then
      mkdir -p "\$singularity_image_directory"
      echo "Directory created: \$singularity_image_directory"
    else
      echo "Directory already exists: \$singularity_image_directory"
    fi

    srun --nodes=1 \
     --ntasks=1 \
     --cpus-per-task=4 \
     --mem=16G \
     --time=1:00:00 \
     singularity build "\$singularity_image_directory/\$repository_name.sif" docker://"$CONTAINER_REGISTRY_REPOSITORY"
  else
    echo "Workspace directory not found."
  fi
EOF
