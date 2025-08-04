#!/bin/bash

# Get project information
title=$(basename "$(pwd)")
PROJECT_ID="marketing-innovation-450013"
SA_EMAIL="$title-sa@$PROJECT_ID.iam.gserviceaccount.com"
imageUrl=gcr.io/$PROJECT_ID/$title

while true; do
    echo "⚠️  WARNING: This will delete the entire project '$title', including:"
    echo "  - GitHub repository"
    echo "  - Docker images and containers"
    echo "  - GCP Service Account"
    echo "  - Local repository"
    echo
    echo "To confirm, please type the project name ($title):"
    echo "Type 'q', 'x', or press ESC to abort."
    # Read input, allowing for ESC detection
    IFS= read -rsn1 confirmation
    # If ESC (ASCII 27), abort
    if [[ $confirmation == $'\e' ]]; then
        echo -e "\nAborted by user (ESC pressed)."
        exit 1
    fi
    # If q or x, abort
    if [[ "$confirmation" == "q" || "$confirmation" == "x" ]]; then
        echo -e "\nAborted by user."
        exit 1
    fi
    # If first char matches, read the rest of the line
    if [[ "$confirmation" == "${title:0:1}" ]]; then
        # Read the rest of the line
        read -rs rest
        confirmation="$confirmation$rest"
    fi
    # Check if input matches project name
    if [[ "$confirmation" == "$title" ]]; then
        break
    else
        echo -e "\nProject name does not match. Try again or type 'q', 'x', or press ESC to abort."
    fi
done

echo "Starting cleanup process..."

# 1. Delete GitHub repository
echo "Deleting GitHub repository..."
gh repo delete $(gh repo view --json nameWithOwner -q .nameWithOwner) --yes || true

# 2. Remove Docker images and containers
echo "Removing Docker resources..."
docker stop $(docker ps -a -q --filter ancestor=$imageUrl) 2>/dev/null || true
docker rmi $imageUrl --force 2>/dev/null || true

# 3. Delete Service Account and its IAM bindings
echo "Removing Service Account and IAM bindings..."
gcloud iam service-accounts delete $SA_EMAIL --quiet || true

# 4. Remove local files
echo "Removing local repository..."
# Store the parent directory path
parent_dir=$(dirname "$(pwd)")
current_dir=$(pwd)

# Change to parent directory before removing the repo
cd "$parent_dir"

# Remove the entire local repository
rm -rf "$current_dir"

echo "Cleanup completed successfully!"
