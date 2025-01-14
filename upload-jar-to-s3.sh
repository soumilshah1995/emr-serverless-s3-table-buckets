#!/bin/bash

# Set your S3 bucket name
S3_BUCKET="<BUCKETNAME>"

# Set Spark version
SPARK_VERSION="3.5"
SCALA_VERSION="2.12"

# Create a temporary directory
TEMP_DIR=$(mktemp -d)
mkdir -p $TEMP_DIR/jars

# Download JAR files
curl -L https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.12.661/aws-java-sdk-bundle-1.12.661.jar -o $TEMP_DIR/jars/aws-java-sdk-bundle-1.12.661.jar
curl -L https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.3.4/hadoop-aws-3.3.4.jar -o $TEMP_DIR/jars/hadoop-aws-3.3.4.jar
curl -L https://repo1.maven.org/maven2/software/amazon/awssdk/bundle/2.29.38/bundle-2.29.38.jar -o $TEMP_DIR/jars/awssdk-bundle-2.29.38.jar
curl -L https://repo1.maven.org/maven2/com/github/ben-manes/caffeine/caffeine/3.1.8/caffeine-3.1.8.jar -o $TEMP_DIR/jars/caffeine-3.1.8.jar
curl -L https://repo1.maven.org/maven2/org/apache/commons/commons-configuration2/2.11.0/commons-configuration2-2.11.0.jar -o $TEMP_DIR/jars/commons-configuration2-2.11.0.jar
curl -L https://repo1.maven.org/maven2/software/amazon/s3tables/s3-tables-catalog-for-iceberg/0.1.3/s3-tables-catalog-for-iceberg-0.1.3.jar -o $TEMP_DIR/jars/s3-tables-catalog-for-iceberg-0.1.3.jar
curl -L https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-spark-runtime-${SPARK_VERSION}_${SCALA_VERSION}/1.6.1/iceberg-spark-runtime-${SPARK_VERSION}_${SCALA_VERSION}-1.6.1.jar -o $TEMP_DIR/jars/iceberg-spark-runtime-${SPARK_VERSION}_${SCALA_VERSION}-1.6.1.jar

# Upload JAR files to S3
aws s3 cp $TEMP_DIR/jars s3://$S3_BUCKET/jars/ --recursive

# Clean up temporary directory
rm -rf $TEMP_DIR

echo "JAR files downloaded and uploaded to S3 bucket: $S3_BUCKET/jars/"
