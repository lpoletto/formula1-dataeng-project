FROM jupyter/pyspark-notebook:latest

USER root

# Instalar dependencias necesarias
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    unzip \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Instalar bibliotecas Python adicionales
RUN pip install --no-cache-dir \
    pymysql \
    sqlalchemy \
    trino \
    minio \
    pandas \
    pyarrow \
    pyhive \
    thrift_sasl \
    ipython-sql \
    delta-spark \
    findspark

# Añadir conectores JDBC para Spark
RUN mkdir -p /opt/spark/jars
RUN curl -L -o /opt/spark/jars/mysql-connector-java-8.0.28.jar https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.28/mysql-connector-java-8.0.28.jar
RUN curl -L -o /opt/spark/jars/mariadb-java-client-2.7.3.jar https://repo1.maven.org/maven2/org/mariadb/jdbc/mariadb-java-client/2.7.3/mariadb-java-client-2.7.3.jar
RUN curl -L -o /opt/spark/jars/minio-7.1.0.jar https://repo1.maven.org/maven2/io/minio/minio/7.1.0/minio-7.1.0.jar
RUN curl -L -o /opt/spark/jars/hadoop-aws-3.3.1.jar https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.3.1/hadoop-aws-3.3.1.jar
RUN curl -L -o /opt/spark/jars/aws-java-sdk-bundle-1.12.196.jar https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.12.196/aws-java-sdk-bundle-1.12.196.jar
RUN curl -L -o /opt/spark/jars/hadoop-common-3.3.1.jar https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-common/3.3.1/hadoop-common-3.3.1.jar

# Configurar permisos
RUN mkdir -p /home/jovyan/notebooks /home/jovyan/shared && \
    chown -R jovyan:users /home/jovyan/notebooks /home/jovyan/shared /opt/spark/jars

USER jovyan

# Configurar variables de entorno para Spark
ENV PYTHONPATH=$SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.9-src.zip:$PYTHONPATH
ENV PYSPARK_PYTHON=python3
ENV PYSPARK_DRIVER_PYTHON=python3