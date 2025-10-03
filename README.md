# Cloudformation AWS Enclave

This CloudFormation template bootstraps an AWS account so it can be part of a Vespa Cloud Enclave.
It configures the global IAM roles and policies required by Vespa Cloud to manage enclave resources inside your account.

Vespa Cloud operates across multiple AWS regions and zones.
To onboard your AWS account into Vespa Cloud, you need to:

1. Deploy the main CloudFormation template once in your account in one of the zones you need. This sets up the global IAM role and permissions Vespa Cloud needs.
2. Deploy the enclave zone template for each additional Vespa Cloud zone you need (only if you need more than one zone).

## Technical Guide

Create an s3 bucket to store the packaged cloudformation templates:
```bash
aws s3 mb s3://vespa-enclave-artifacts --region us-east-1
```


Package and upload the enclave templates to s3:
```bash
aws cloudformation package \
  --template-file ./templates/enclave-main.yml \
  --s3-bucket vespa-enclave-artifacts \
  --output-template-file packaged.yml \
  --region us-east-1
```

Create a change set for the template. Update `create-change-set.sh` to use the correct parameters, and execute it to upload the changeset to AWS:
```bash
./create-change-set.sh
```

After uploading, you can describe the changes:
```bash
aws cloudformation describe-change-set \
  --stack-name vespa-enclave \
  --change-set-name <change-set-name> \
  --region us-east-1
```

The changes should show that the template will add a new `ProvisionStack` and `ZoneStack`. When you are ready to apply the changes, run:
```bash
aws cloudformation execute-change-set \
  --stack-name vespa-enclave \
  --change-set-name <change-set-name> \
  --region us-east-1
```

Cloudformation will now create the neccessary resources for Vespa Cloud enclave.


**Based on terraform-aws-enclave commit `f24d172` (21.08.25)**
