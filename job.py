from pyspark.sql import SparkSession

print("START")

# Initialize SparkSession without explicit configurations
spark = SparkSession.builder \
    .appName("iceberg_lab") \
    .getOrCreate()

print("SPARK SESSION READY")
spark.sql("SHOW NAMESPACES IN catalog1").show()
spark.sql("CREATE NAMESPACE IF NOT EXISTS catalog1.demo_poc_bucket1")

print("NAMESPACE CREATED")

spark.sql("""
CREATE TABLE IF NOT EXISTS catalog1.demo_poc_bucket1.customers (
  customer_id INT,
  name STRING,
  email STRING
) USING iceberg
""")
spark.sql("""
INSERT INTO catalog1.demo_poc_bucket1.customers VALUES
  (1, 'John Doe', 'john@example.com'),
  (2, 'Jane Smith', 'jane@example.com'),
  (3, 'Bob Johnson', 'bob@example.com'),
  (4, 'Alice Brown', 'alice@example.com'),
  (5, 'Charlie Davis', 'charlie@example.com')
""")
print("INSERT OK")

print("DONE")
print(
    spark.sql("""
    SELECT *
    FROM catalog1.demo_poc_bucket1.customers
    """).show()
)
