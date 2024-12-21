# #!/bin/bash

# set -e

# echo "Deploying ECS Task Definition and Updating Service..."

# # Register new ECS task definition with the updated image URI
# TASK_DEF_ARN=$(aws ecs register-task-definition \
#   --family ecs-task \  # Replace with your actual ECS task family name
#   --execution-role-arn arn:aws:iam::965080479351:role/ecsTaskExecutionRole \  # Ensure correct execution role
#   --network-mode awsvpc \  # Use awsvpc for Fargate tasks
#   --requires-compatibilities FARGATE \  # Specify Fargate compatibility
#   --cpu "256" \  # Adjust CPU settings for Fargate task
#   --memory "512" \  # Adjust memory settings for Fargate task
#   --container-definitions file://imagedefinitions.json \  # Use imagedefinitions.json for container definition
#   --query "taskDefinition.taskDefinitionArn" \
#   --output text)

# echo "New ECS task definition registered: $TASK_DEF_ARN"

# # Update ECS service to use the new task definition
# aws ecs update-service \
#   --cluster my-cluster \  # Replace with your ECS cluster name
#   --service ecs-service \  # Replace with your ECS service name
#   --task-definition $TASK_DEF_ARN \
#   --desired-count 1 \
#   --launch-type FARGATE \  # Specify that you are using Fargate
#   --network-configuration "awsvpcConfiguration={subnets=[subnet-05e0b0459f829449b,subnet-0308d5b29833bac55,subnet-018f6699510ccb093],securityGroups=[sg-0b4eac0a57772cd31],assignPublicIp=ENABLED}"  # Update with correct subnet and security group

# echo "ECS service updated with the new task definition."



#!/bin/bash

# This script should be executed during the "AfterInstall" phase of the CodeDeploy process

# Set the AWS region
export AWS_REGION="ap-southeast-1"

# Get the task definition ARN, this should be passed as part of the CodeDeploy deployment process or pipeline
TASK_DEFINITION_ARN="arn:aws:ecs:ap-southeast-1:965080479351:task-definition/ecs-task"  # Use quotes for the ARN
ECS_CLUSTER_NAME="my-cluster"  # Use quotes for ECS cluster name
ECS_SERVICE_NAME="ecs-service"  # Use quotes for ECS service name

# Log out the values for debugging
echo "Task Definition ARN: $TASK_DEFINITION_ARN"
echo "ECS Cluster: $ECS_CLUSTER_NAME"
echo "ECS Service: $ECS_SERVICE_NAME"

# Update the ECS service with the new task definition
aws ecs update-service \
  --cluster $ECS_CLUSTER_NAME \
  --service $ECS_SERVICE_NAME \
  --task-definition $TASK_DEFINITION_ARN \
  --force-new-deployment \
  --region $AWS_REGION
