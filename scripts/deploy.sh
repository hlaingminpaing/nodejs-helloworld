#!/bin/bash

set -e

echo "Deploying ECS Task Definition and Updating Service..."

# Replace <IMAGE_URI> with the actual ECR image URI
IMAGE_URI="$ECR_REGISTRY/$IMAGE_REPO_NAME:$CODEBUILD_RESOLVED_SOURCE_VERSION"

# Register new ECS task definition with the updated image URI
TASK_DEF_ARN=$(aws ecs register-task-definition \
  --family my-ecs-task-family \
  --container-definitions "[
    {
      \"name\": \"app-container\",
      \"image\": \"$IMAGE_URI\",
      \"memory\": 512,
      \"cpu\": 256,
      \"essential\": true,
      \"portMappings\": [
        {
          \"containerPort\": 3000,
          \"hostPort\": 3000
        }
      ]
    }
  ]" \
  --query "taskDefinition.taskDefinitionArn" \
  --output text)

echo "New ECS task definition registered: $TASK_DEF_ARN"

# Update ECS service to use the new task definition
aws ecs update-service \
  --cluster my-ecs-cluster-name \
  --service my-ecs-service-name \
  --task-definition $TASK_DEF_ARN \
  --desired-count 1

echo "ECS service updated with the new task definition."
