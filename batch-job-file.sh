#!/bin/bash

#SBATCH --job-name=kedro-job
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=10:00:00
#SBATCH --output=%j.out
#SBATCH --error=%j.err

# Get the path of the script.
if [ -n "$SLURM_JOB_ID" ]; then
  SCRIPT_PATH=$(scontrol show job "$SLURM_JOBID" | awk -F= '/Command=/{print $2}')
else
  SCRIPT_PATH="$(realpath "$0")"
fi

# Get the name of the repository.
CURRENT_DIR="$(basename "$(dirname "$SCRIPT_PATH")")"

JOB_NAME="${CURRENT_DIR}-job"

srun singularity exec -c --bind "$CURRENT_DIR"/:/home/kedro_docker --pwd /home/kedro_docker singularity-images/"$CURRENT_DIR".sif kedro run
