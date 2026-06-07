#### Pre-requisite: setup remote backend

- aws s3 mb s3://rds-project-terraform-state-944368523146
- Enable versioning
  ```
  aws s3api put-bucket-versioning \
  --bucket rds-project-terraform-state-944368523146 \
  --versioning-configuration Status=Enabled
  ```
- Enable server-side encryption
  ```
  aws s3api put-bucket-encryption \
  --bucket rds-project-terraform-state-944368523146 \
  --server-side-encryption-configuration '{
      "Rules": [{
      "ApplyServerSideEncryptionByDefault": {
          "SSEAlgorithm": "AES256"
      }
      }]
  }'
  ```
- Create DynamoDB table for state locking

```
aws dynamodb create-table \
  --table-name rds-project-terraform-state-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST
```

### CleanUP

1. Delete DynamoDB Lock Table:

```
aws dynamodb delete-table \
  --table-name rds-project-terraform-state-locks
```

2. Check deletion:

```
aws dynamodb list-tables
```

3. Delete ALL objects

```
aws s3 rm s3://rds-project-terraform-state-944368523146 --recursive
```

4. Delete ALL versions

```
aws s3api delete-objects \
--bucket rds-project-terraform-state-944368523146 \
--delete "$(aws s3api list-object-versions \
--bucket rds-project-terraform-state-944368523146 \
--query '{Objects: Versions[].{Key:Key,VersionId:VersionId}}' \
--output json)"
```

5. Delete delete-markers

```
aws s3api delete-objects \
--bucket rds-project-terraform-state-944368523146 \
--delete "$(aws s3api list-object-versions \
--bucket rds-project-terraform-state-944368523146 \
--query '{Objects: DeleteMarkers[].{Key:Key,VersionId:VersionId}}' \
--output json)"
```

6. Finally delete bucket

```
aws s3api delete-bucket \
--bucket rds-project-terraform-state-944368523146
```

Step 2/3 fails (simpler force method)

```
aws s3 rm s3://rds-project-terraform-state-944368523146 --recursive
aws s3api delete-bucket --bucket rds-project-terraform-state-944368523146
```
