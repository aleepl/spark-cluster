FROM python:3.11.5

# Add Dependencies
RUN apt-get update &&\
    apt-get install -y ssh net-tools ca-certificates openssh-server &&\
    apt-get update

# Set environmental variables
ENV JAVA_VERSION=11
ENV SCALA_VERSION=2.12.4
ENV SPARK_VERSION=3.5.0
ENV JAVA_HOME="/opt/java"
ENV SCALA_HOME="/opt/scala"
ENV SPARK_HOME="/opt/spark"
ENV HADOOP_HOME="/opt/spark"
ENV PATH="${PATH}:${JAVA_HOME}/bin"
ENV PATH="${PATH}:${SCALA_HOME}/bin"
ENV PATH="${PATH}:${SPARK_HOME}/bin"
ENV PYTHONPATH="${PYTHONPATH}:${SPARK_HOME}/python"
ENV PYSPARK_PYTHON=python3
ENV SPARK_MASTER_PORT=7077
ENV SPARK_MASTER="spark://spark-master:${SPARK_MASTER_PORT}"
ENV SPARK_MASTER_HOST=spark-master

# Set docker parameters
ARG SOURCE_JAVA="https://download.java.net/java/GA/jdk${JAVA_VERSION}/9/GPL/openjdk-${JAVA_VERSION}.0.2_linux-x64_bin.tar.gz"
ARG SOURCE_SCALA="https://downloads.lightbend.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.tgz"
ARG SOURCE_SPARK="https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz"
ARG TARGET_JAVA="/opt/java.tar.gz"
ARG TARGET_SCALA="/opt/scala.tgz"
ARG TARGET_SPARK="/opt/apache-spark.tgz"

# Install Java 8
RUN mkdir -p "${JAVA_HOME}"
RUN curl "${SOURCE_JAVA}" --output "${TARGET_JAVA}"
RUN tar -zxvf "${TARGET_JAVA}" -C "${JAVA_HOME}" --strip-components=1
RUN rm "${TARGET_JAVA}"
RUN java -version

# Install Scala
RUN mkdir -p "${SCALA_HOME}"
RUN curl "${SOURCE_SCALA}" --output "${TARGET_SCALA}"
RUN tar -zxvf "${TARGET_SCALA}" -C "${SCALA_HOME}" --strip-components=1
RUN rm "${TARGET_SCALA}"
RUN scala -version

# Install Spark
RUN mkdir -p "${SPARK_HOME}"
RUN curl "${SOURCE_SPARK}" --output "${TARGET_SPARK}"
RUN tar -zxvf "${TARGET_SPARK}" -C "${SPARK_HOME}" --strip-components=1
RUN rm "${TARGET_SPARK}"
RUN pyspark --version

# Copy files
COPY ./requirements.txt /opt/
COPY ./spark-env.sh /opt/spark/conf
COPY ./entrypoint.sh /opt/

# Install python requirements
RUN pip install --upgrade pip
RUN pip install -r /opt/requirements.txt

WORKDIR /opt/spark
