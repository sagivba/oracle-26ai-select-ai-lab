#!/bin/bash
# Backup script for the oracle26ai Docker environment.
# It saves container metadata, volume metadata, and the image name,
# then stops the container, archives the Docker volume data,
# and starts the container again.
# Sagiv Barhoom 2026

set -e  # Exit immediately if a command fails.

CONTAINER_NAME=oracle26ai
VOLUME_NAME=oracle26ai-data
BACKUP_ROOT=backups
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR=${BACKUP_ROOT}/${TIMESTAMP}
CONTAINER_INSPECT="${BACKUP_DIR}/container_inspect.json"
VOLUME_INSPECT="${BACKUP_DIR}/volume_inspect.json"
DOCKER_IMAGE_FILE="${BACKUP_DIR}/image_name.txt"

mkdir -pv "${BACKUP_DIR}"  # Creates the timestamped backup directory if it does not already exist.

# Save container configuration and metadata to a JSON file.
docker inspect "${CONTAINER_NAME}" > $CONTAINER_INSPECT && echo "Container metadata saved to ${CONTAINER_INSPECT}" || { echo "Failed to save container metadata"; exit 1; }

# Save Docker volume configuration and metadata to a JSON file.
docker volume inspect "${VOLUME_NAME}" > $VOLUME_INSPECT && echo "Volume metadata saved to ${VOLUME_INSPECT}" || { echo "Failed to save volume metadata"; exit 1; }

# Save the image name used by the container to a text file.
docker inspect --format='' "${CONTAINER_NAME}" > $DOCKER_IMAGE_FILE && echo "Image name saved to ${DOCKER_IMAGE_FILE}" || { echo "Failed to save image name"; exit 1; }

# Stop the container before backing up the volume data.
docker stop "${CONTAINER_NAME}"

# if docker run --rm \                   - Runs a temporary container and removes it automatically when finished.
#  -v "${VOLUME_NAME}":/volume \        - Mounts the Docker volume into the temporary container at /volume.
#  -v "$(pwd)/${BACKUP_DIR}":/backup \  - Mounts the local backup directory into the temporary container at /backup.
#  alpine sh -c 'tar czf /backup/oradata.tar.gz -C /volume .' - Uses Alpine Linux to create a compressed tar.gz archive
#               
echo "Creating backup archive, this may take a while..."
if docker run --rm \
  -v "${VOLUME_NAME}:/volume" \
  -v "$(pwd)/${BACKUP_DIR}:/backup" \
  alpine sh -c 'tar czf /backup/oradata.tar.gz -C /volume .'
then
  echo "Backup completed successfully. Backup file: $(pwd)/${BACKUP_DIR}/oradata.tar.gz"
else
  echo "Backup failed. Check backup directory: $(pwd)/${BACKUP_DIR}"
  exit 1
fi
echo "Backup created at: $(pwd)/${BACKUP_DIR}"
ls -lh "${BACKUP_DIR}"  


# Start the container again after the backup is complete.
docker start "${CONTAINER_NAME}"