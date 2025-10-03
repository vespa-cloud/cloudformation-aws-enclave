#!/usr/bin/env bash
set -euo pipefail

# Stack and change set name
STACK_NAME="vespa-enclave"
CHANGE_SET_NAME="vespa-enclave-$(date +%Y%m%d-%H%M%S)"

# Region, tenant, account
TENANT_NAME="my-tenant"
VESPA_CLOUD_ACCOUNT="332934501266"
REGION="us-east-1"

# Zone configuration
ZONE_ENVIRONMENT="dev"
ZONE_REGION="aws-us-east-1c"
ZONE_NAME="dev.aws-us-east-1c"
ZONE_TAG="dev.aws-us-east-1c"
ZONE_AZ_ID="use1-az6"
ZONE_TEMPLATE_VERSION="1"

# Extra configuration
ZONE_IPV4_CIDR="10.128.0.0/16"
ARCHIVE_READER_PRINCIPALS=""

# Aws action type
CHANGE_SET_TYPE="CREATE"

echo "Creating CloudFormation change set '$CHANGE_SET_NAME' for stack '$STACK_NAME' in region '$REGION'..."

aws cloudformation create-change-set \
  --stack-name "$STACK_NAME" \
  --template-body file://packaged.yml \
  --change-set-name "$CHANGE_SET_NAME" \
  --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
  --region "$REGION" \
  --change-set-type "$CHANGE_SET_TYPE" \
  --parameters \
      ParameterKey=TenantName,ParameterValue="$TENANT_NAME" \
      ParameterKey=VespaCloudAccount,ParameterValue="$VESPA_CLOUD_ACCOUNT" \
      ParameterKey=DefaultRegion,ParameterValue="$REGION" \
      ParameterKey=ZoneEnvironment,ParameterValue="$ZONE_ENVIRONMENT" \
      ParameterKey=ZoneRegion,ParameterValue="$ZONE_REGION" \
      ParameterKey=ZoneName,ParameterValue="$ZONE_NAME" \
      ParameterKey=ZoneTag,ParameterValue="$ZONE_TAG" \
      ParameterKey=ZoneAvailabilityZoneId,ParameterValue="$ZONE_AZ_ID" \
      ParameterKey=ZoneTemplateVersion,ParameterValue="$ZONE_TEMPLATE_VERSION" \
      ParameterKey=ZoneIPv4Cidr,ParameterValue="$ZONE_IPV4_CIDR"
      # ParameterKey=ArchiveReaderPrincipals,ParameterValue="$ARCHIVE_READER_PRINCIPALS"

# Nice!
echo "✅ Change set '$CHANGE_SET_NAME' created."
echo
echo "You can inspect it in the AWS Console:"
echo "https://${REGION}.console.aws.amazon.com/cloudformation/home?region=${REGION}#/stacks/changesets"

echo
echo "Or via CLI:"
echo "aws cloudformation describe-change-set \\"
echo "  --stack-name $STACK_NAME \\"
echo "  --change-set-name $CHANGE_SET_NAME \\"
echo "  --region $REGION"
