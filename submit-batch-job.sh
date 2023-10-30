#!/bin/sh

set -e

# This script will SSH into the HPC, check if the workspace directory exists, if yes it will submit the SLURM job
# which will run Kedro pipeline to the batch system for later execution.

ssh -T "$SSH_USER"@"$HPC_ADDRESS" /bin/bash <<EOF

  # Move to the target directory if it exists
  if [ -d $WORKSPACE_DIR ]; then
    cd $WORKSPACE_DIR
    echo "Workspace directory exists. Current directory: \$(pwd)"

    # Submit the batch job
    repository_name=$(basename "$REPO_CLONE_URL" .git)
    sbatch "\$repository_name/batch-job-file.sh"
  else
    echo "Workspace directory not found."
  fi
EOF
