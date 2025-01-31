#!/bin/bash
set -e  # Exit on error

apk add --no-cache curl

echo "Waiting for vector storage to be ready..."
BASEURL="http://$VECTOR_STORAGE_HOST:6333"
until curl -sSf "$BASEURL/healthz" > /dev/null; do
    sleep 5
done
echo "Vector storage is ready!"

# Set the snapshot directory path
SNAPSHOT_DIR="/snapshots"

# Loop over all snapshot files in the directory and restore each one
for snapshot in "$SNAPSHOT_DIR"/*.snapshot; do
    if [ -e "$snapshot" ]; then
        COLLECTION_NAME=$(basename "$snapshot" .snapshot)  # Use filename as collection name
        echo "Restoring snapshot for collection $COLLECTION_NAME..."

        echo "Checking if collection '$COLLECTION_NAME' already exists..."
        COLLECTION_EXISTS=$(curl -s -X GET "$BASEURL/collections/$COLLECTION_NAME/exists" | grep -c '"result":{"exists":true}')

        if [ "$COLLECTION_EXISTS" -gt 0 ]; then
            echo "Collection '$COLLECTION_NAME' already exists. Skipping upload."
        else
            echo "Restoring snapshot for collection '$COLLECTION_NAME'..."
            # Upload the snapshot to Qdrant
            curl -v -X POST "$BASEURL/collections/$COLLECTION_NAME/snapshots/upload" \
                -F "snapshot=@$snapshot"
        fi
    fi
done

echo "Snapshots restoration finished successfully."
