# README

## Setup

```bash
❯ brew install awscli tfenv aws-vault packer
❯ aws configure
```

## Needed

* AWS CLI Profile called "terraform"
* IAM user with Programmatic Access, "AdministratorAccess" Policy, plus following Policies
* S3 bucket called "unique-bucket-name"
* DynamoDB called "terraform-state-lock"

**TerraformRemoteState**
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::unique-bucket-name"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject"
            ],
            "Resource": "arn:aws:s3:::unique-bucket-name/*"
        }
    ]
}
```

**TerraformStateLock**
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "dynamodb:PutItem",
                "dynamodb:DeleteItem",
                "dynamodb:GetItem"
            ],
            "Resource": "arn:aws:dynamodb:eu-west-2:338122837542:table/terraform-state-lock"
        }
    ]
}
```

```bash
❯ aws-vault add terraform
❯ aws-vault exec terraform -- aws sts get-caller-identity
{
    "UserId": "AIDAU5ONRBYTKFRBOKMDY",
    "Account": "338122837542",
    "Arn": "arn:aws:iam::338122837542:user/terraform"
}
❯ tfenv use
❯ aws-vault exec terraform -- terraform init
❯ aws-vault exec terraform -- packer build firstawsami-packer.json
❯ aws-vault exec terraform -- terraform plan
❯ aws-vault exec terraform -- terraform apply
```