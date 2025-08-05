#!/bin/bash

# Project initialization script


title=$(basename "$(pwd)")
cicd=.github/workflows/cicd.yaml
PROJECT_ID=marketing-innovation-450013
imageUrl=gcr.io/$PROJECT_ID/$title
SA_EMAIL=$title-sa@$PROJECT_ID.iam.gserviceaccount.com
SA_NAME=$(echo $title | tr '[:lower:]' '[:upper:]')_SA

echo -n "Enter region (default: europe-west4): "
read region
if [ -z "$region" ]; then
  region="europe-west4"
fi

# Update project name 
sed -i '' "s/name = \"bff-template\"/name = \"$title\"/" pyproject.toml

# Update cicd
sed -i '' "s/name = \"  if: false\"/name = \"\"/" $cicd
sed -i '' "s/name = \"BFF_TEMPLATE_SA\"/name = \"$SA_NAME\"/" $cicd
sed -i '' "s/name = \"bff-template-service-name\"/name = \"$title\"/" $cicd
sed -i '' "s/name = \"bff-template-image-url\"/name = \"$imageUrl\"/" $cicd


# Create and setup frontend
echo "Creating frontend..."
mkdir -p frontend
cd frontend && npx create-react-app . && npm run build
echo "Frontend setup complete"

# Setup backend
echo "Creating backend..."
poetry install --no-root

# Create docker container
colima start

docker build -t $imageUrl .
docker push $imageUrl

# Create Service Account
gcloud iam service-accounts create $title-sa \
    --display-name="$title Service Account" \
    --project=$PROJECT_ID


gcloud projects add-iam-policy-binding $PROJECT_ID\
      --member="serviceAccount:$SA_EMAIL" \
      --role="roles/run.admin" \
      --role="roles/iam.serviceAccountUser" \
      --role="roles/storage.admin" \
      --role="roles/artifactregistry.admin" \
      --role="roles/run.developer" \
      --role="roles/storage.admin" \
      --role="roles/iam.serviceAccountUser"

gcloud iam service-accounts keys create - --iam-account=$SA_EMAIL | gh secret set SA_NAME

echo -e "Set your python interpreter to be: \033[33m$(poetry env info --path)\033[0m"
echo "You can run everything using the 'make local' command"




# This is to prevent from running more than once
chmod 000 init.sh

# Additional initialization tasks from comments:
# TODO: Update these values in your deployment configuration:
# - cicd should use the new github secret
# - create a standard init and a special one for me