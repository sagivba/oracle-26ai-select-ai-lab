#!/bin/bash
# Restore script for the oracle26ai Docker environment.
# It reads the image name from the backup folder, creates the Docker volume,
# restores the archived Oracle data into the volume,
# and starts a new oracle26ai container using the restored data.
# Sagiv Barhoom 2026

set -e  # Exit immediately if a command fails.

BACKUP_DIR=$1
NEW_VOLUME_NAME=oracle26ai-data

# Validate that a backup directory argument was provided.
if [ -z "${BACKUP_DIR}" ]; then
  echo "Restore failed. Usage: $0 <backup_directory>"
  exit 1
fi

# Read the Docker image name from the backup metadata file.
IMAGE_NAME=$(cat "${BACKUP_DIR}/image_name.txt")

# Create the Docker volume that will hold the restored Oracle data.
docker volume create "${NEW_VOLUME_NAME}"

if docker run --rm \                   # Runs a temporary container and removes it automatically when finished.
  -v "${NEW_VOLUME_NAME}":/volume \    # Mounts the target Docker volume into the temporary container at /volume.
  -v "$(pwd)/${BACKUP_DIR}":/backup \  # Mounts the selected backup directory into the temporary container at /backup.
  alpine sh -c 'cd /volume && tar xzf /backup/oradata.tar.gz'
                                       # Uses Alpine Linux to extract the compressed backup archive
                                       # from /backup into the restored Docker volume at /volume.
then
  # Print restore success status and the restored volume name.
  echo "Restore data extraction completed successfully. Restored volume: ${NEW_VOLUME_NAME}"
else
  # Print restore failure status and the backup archive location.
  echo "Restore failed during data extraction. Backup file: $(pwd)/${BACKUP_DIR}/oradata.tar.gz"
  exit 1
fi

# Start a new oracle26ai container using the restored volume and saved image name.
docker run -d \
  --name oracle26ai \                  # Creates and starts a container named oracle26ai.
  -p 1521:1521 \                       # Maps port 1521 from the container to port 1521 on the host.
  -e ORACLE_PWD=Oracle123 \            # Sets the Oracle password inside the container.
  -v "${NEW_VOLUME_NAME}":/opt/oracle/oradata \  # Mounts the restored Docker volume as the Oracle data directory.
  "${IMAGE_NAME}"

# Print final restore status after the container starts.
echo "Restore completed successfully. Container: oracle26ai, Volume: ${NEW_VOLUME_NAME}"