#!/bin/bash

set -e

echo "Deploying ECS Task Definition and Updating Service..."

# Register new ECS task definition with the updated image URI
TASK_DEF_ARN=$(aws ecs register-task-definition \
  --family ecs-task \  # Replace with your actual ECS task family name
  --execution-role-arn arn:aws:iam::965080479351:role/ecsTaskExecutionRole \  # Ensure correct execution role
  --network-mode awsvpc \  # Use awsvpc for Fargate tasks
  --requires-compatibilities FARGATE \  # Specify Fargate compatibility
  --cpu "256" \  # Adjust CPU settings for Fargate task
  --memory "512" \  # Adjust memory settings for Fargate task
  --container-definitions file://imagedefinitions.json \  # Use imagedefinitions.json for container definition
  --query "taskDefinition.taskDefinitionArn" \
  --output text)

echo "New ECS task definition registered: $TASK_DEF_ARN"

# Update ECS service to use the new task definition
aws ecs update-service \
  --cluster my-cluster \  # Replace with your ECS cluster name
  --service ecs-service \  # Replace with your ECS service name
  --task-definition $TASK_DEF_ARN \
  --desired-count 1 \
  --launch-type FARGATE \  # Specify that you are using Fargate
  --network-configuration "awsvpcConfiguration={subnets=[subnet-05e0b0459f829449b,subnet-0308d5b29833bac55,subnet-018f6699510ccb093],securityGroups=[sg-0b4eac0a57772cd31],assignPublicIp=ENABLED}"  # Update with correct subnet and security group

echo "ECS service updated with the new task definition."
