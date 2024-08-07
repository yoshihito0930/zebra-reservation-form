#!/bin/bash

set -e

# Preparation
SSM_SERVICE_ROLE_NAME="SSMServiceRole"
SSM_ACTIVATION_FILE="code.json"
AWS_REGION="ap-northeast-1"

echo "Starting SSM activation process..."

# Create Activation Code on Systems Manager
echo "Creating SSM activation..."
if ! aws ssm create-activation \
  --description "Activation Code for Fargate Bastion" \
  --default-instance-name bastion \
  --iam-role ${SSM_SERVICE_ROLE_NAME} \
  --registration-limit 1 \
  --tags Key=Type,Value=Bastion \
  --region ${AWS_REGION} > ${SSM_ACTIVATION_FILE}
then
  echo "Failed to create SSM activation. Check your IAM permissions and network connectivity."
  echo "AWS CLI output:"
  cat ${SSM_ACTIVATION_FILE}
  exit 1
fi

echo "SSM activation created successfully."

SSM_ACTIVATION_ID=$(jq -r .ActivationId ${SSM_ACTIVATION_FILE})
SSM_ACTIVATION_CODE=$(jq -r .ActivationCode ${SSM_ACTIVATION_FILE})
rm -f ${SSM_ACTIVATION_FILE}

echo "Activating SSM Agent..."
# Activate SSM Agent on Fargate Task
if ! amazon-ssm-agent -register -code "${SSM_ACTIVATION_CODE}" -id "${SSM_ACTIVATION_ID}" -region ${AWS_REGION} -y
then
  echo "Failed to activate SSM Agent."
  exit 1
fi

echo "SSM Agent activated successfully."

echo "Deleting SSM activation..."
# Delete Activation Code
if ! aws ssm delete-activation --activation-id ${SSM_ACTIVATION_ID} --region ${AWS_REGION}
then
  echo "Failed to delete SSM activation. Please delete it manually."
fi

echo "Starting SSM Agent..."
# Execute SSM Agent
exec amazon-ssm-agent