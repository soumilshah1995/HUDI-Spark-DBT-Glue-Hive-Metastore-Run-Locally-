# HUDI-Spark-DBT-Glue-Hive-Metastore-Run-Locally-
HUDI + Spark+ DBT + Glue Hive Metastore Run Locally 
![Screenshot 2023-12-24 at 9 57 17 AM](https://github.com/soumilshah1995/HUDI-Spark-DBT-Glue-Hive-Metastore-Run-Locally-/assets/39345855/7e727135-8f74-41a4-bf68-8b307b07a623)

# Steps 

# Step 1: Create AWS Glue Profile 
```agsl
aws configure --profile glue4
```

# Step 2: Clone teh project and Edit the following line in docker compose file
```agsl
version: '3.7'
services:
  jupyter:
    container_name: glue_jupyter
    command: /home/glue_user/jupyter/jupyter_start.sh && sudo chown -R 10000:10000 /home/glue_user/workspace/jupyter_workspace
    environment:
      - DISABLE_SSL=true
      - AWS_PROFILE=glue4
      - DATALAKE_FORMATS=hudi
      - PYTHONPATH=$PYTHONPATH:/home/glue_user/workspace/extra_python_path/
    image: amazon/aws-glue-libs:glue_libs_4.0.0_image_01
    ports:
      - '4040:4040' # Spark web UI
      - '4041:4041' # Spark web UI
      - '18080:18080' # Spark History server
      - '18081:18081' # Spark History server
      - '8998:8998' # Jupyter web server
      - '8888:8888' # Jupyter web server
      -  '10000:10000'
      -  '10001:10001'
    restart: always
    volumes:
      -  /Users/XXXX/.aws:/home/glue_user/.aws
      - ./glue_jupyter_workspace:/home/glue_user/workspace/jupyter_workspace/
      - ./extra_python_path:/home/glue_user/workspace/extra_python_path/
```

# Step 3: Start the Contaniner 
```agsl
docker-compose up --build 

```

# Step 4: Exec into Container and Start Thrift server

```agsl

cd /home/glue_user/spark

./sbin/start-thriftserver.sh \
  --conf 'spark.serializer=org.apache.spark.serializer.KryoSerializer'   \
  --conf 'spark.sql.extensions=org.apache.spark.sql.hudi.HoodieSparkSessionExtension'  \
  --conf 'spark.kryo.registrator=org.apache.spark.HoodieSparkKryoRegistrar' \
  --conf 'spark.sql.warehouse.dir=s3a://soumil-dev-bucket-1995/warehouse' \
  --packages 'org.apache.hudi:hudi-spark3.3-bundle_2.12:0.14.0'
  "$@"

```
# Step 5: Optional Connect and test using beeline if needed 
```agsl
beeline -u jdbc:hive2://localhost:10000/default

```

# Step 6: Create and Install DBT dependencies 
```agsl

# Create a virtual environment
python -m venv dbt-env

# Activate the virtual environment
source dbt-env/bin/activate

# Install DBT Core
pip install dbt-core

# Install DBT Spark
pip install dbt-spark

# Install PyHive for Spark integration
pip install 'dbt-spark[PyHive]'

```

# Step 7: Create DBT project
```agsl
dbt init

<Follow Video Guide and enter values for prompt>
```

# Step 8: RUN DBT 
```agsl
dbt debug 
dbt run
```
