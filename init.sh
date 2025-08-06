#!/bin/bash

# Project initialization script

title=$(basename "$(pwd)" | tr '[:upper:]' '[:lower:]')
cicd=.github/workflows/cicd.yaml
PROJECT_ID=marketing-innovation-450013
imageUrl=gcr.io/$PROJECT_ID/$title
SA_EMAIL=$title-sa@$PROJECT_ID.iam.gserviceaccount.com
SA_NAME=$(echo $title | tr '[:lower:]' '[:upper:]' | tr '-' '_')_SA

# Ask for deployment type
echo -n "Enter deployment type (local/admin, default: local): "
read deployment_type
if [ -z "$deployment_type" ] || [ "$deployment_type" != "admin" ]; then
  deployment_type="local"
fi

echo -n "Enter region (default: europe-west4): "
read region
if [ -z "$region" ]; then
  region="europe-west4"
fi

touch .env
# Update project name 
sed -i '' "s/name = \"bff-template\"/name = \"$title\"/" pyproject.toml
sed -i '' "s/name = \"bff-template\"/name = \"$title\"/" makefile

# Setup frontend
echo "Creating frontend..."
mkdir -p frontend
cd frontend && npx create-react-app . && npm run build
echo "Frontend setup complete"

# Setup backend
echo "Creating backend..."
poetry install --no-root

# Update cicd
sed -i '' "s/name = \"BFF_TEMPLATE_SA\"/name = \"$SA_NAME\"/" $cicd
sed -i '' "s/name = \"bff-template-service-name\"/name = \"$title\"/" $cicd
sed -i '' "s/name = \"bff-template-image-url\"/name = \"$imageUrl\"/" $cicd

# Admin section
if [ "$deployment_type" = "admin" ]; then
  echo "Running admin setup..."
  
  # Activate cicd
  sed -i '' "s/name = \"  if: false\"/name = \"\"/" $cicd

  # Create docker container
  colima start
  docker build -t $imageUrl .
  docker push $imageUrl

  # Create Service Account
  gcloud iam service-accounts create $title-sa \
      --display-name="$title Service Account" \
      --project=$PROJECT_ID

  gcloud iam service-accounts create $title-sa \
      --display-name="$title Service Account" \
      --project=$PROJECT_ID

  gcloud projects add-iam-policy-binding $PROJECT_ID \
        --member="serviceAccount:$SA_EMAIL" \
        --role="roles/run.admin"

  gcloud projects add-iam-policy-binding $PROJECT_ID \
        --member="serviceAccount:$SA_EMAIL" \
        --role="roles/iam.serviceAccountUser"

  gcloud projects add-iam-policy-binding $PROJECT_ID \
        --member="serviceAccount:$SA_EMAIL" \
        --role="roles/storage.admin"

  gcloud projects add-iam-policy-binding $PROJECT_ID \
        --member="serviceAccount:$SA_EMAIL" \
        --role="roles/artifactregistry.admin"

  gcloud projects add-iam-policy-binding $PROJECT_ID \
        --member="serviceAccount:$SA_EMAIL" \
        --role="roles/run.developer"

  gcloud iam service-accounts keys create sa-key.json --iam-account=$SA_EMAIL

  gh secret set $SA_NAME < sa-key.json

  rm sa-key.json
  
  colima stop
  echo "Admin setup completed"
fi

echo -e "Set your python interpreter to be: \033[33m$(poetry env info --path)\033[0m"
echo "You can run everything using the 'make local' command"




# This is to prevent from running more than once
chmod 666 init.sh
