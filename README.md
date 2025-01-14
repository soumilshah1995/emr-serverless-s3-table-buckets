# emr-serverless-s3-table-buckets
emr-serverless-s3-table-buckets

# Steps 


#### Step 1: Deploy jar on S3
```
./upload-jar-to-s3.sh
```
#### Step 2: Deploy Job  on S3
```
export BUCKET=""
aws s3 rm s3://$BUCKET/jobs/jobv2.py
aws s3 cp <path>/jobv2.py s3://$BUCKET/jobs/jobv2.py

```

#### Step 3: Run job
```
# Define environment variables
export APPLICATION_ID=""
export IAM_ROLE="arn:aws:iam::XX:role/EMRServerlessS3RuntimeRole"
export WAREHOUSE_ARN="XX"

# Start EMR Serverless job run
aws emr-serverless start-job-run \
    --application-id $APPLICATION_ID \
    --name "TableBucketsJobRun" \
    --execution-role-arn $IAM_ROLE \
    --job-driver '{
        "sparkSubmit": {
            "entryPoint": "s3://'$BUCKET'/jobs/jobv2.py",
            "sparkSubmitParameters": "--jars s3://'$BUCKET'/jars/* --conf spark.sql.catalog.catalog1=org.apache.iceberg.spark.SparkCatalog --conf spark.sql.catalog.catalog1.catalog-impl=software.amazon.s3tables.iceberg.S3TablesCatalog --conf spark.sql.catalog.catalog1.warehouse='$WAREHOUSE_ARN' --conf spark.sql.extensions=org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions --conf spark.sql.catalog.defaultCatalog=catalog1 --conf spark.sql.catalog.catalog1.client.region=us-east-1"
        }
    }' \
    --configuration-overrides '{
        "monitoringConfiguration": {
            "s3MonitoringConfiguration": {
                "logUri": "s3://'$BUCKET'/logs/"
            }
        }
    }'

```
