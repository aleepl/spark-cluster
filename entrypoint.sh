#!/bin/bash

SPARK_WORKLOAD=$1

if [ "$SPARK_WORKLOAD" == "master" ];
then
  "${SPARK_HOME}/sbin"/start-master.sh -p 7077
elif [ "$SPARK_WORKLOAD" == "worker" ];
then
  "${SPARK_HOME}/sbin"/start-worker.sh spark://spark-master:7077
elif [ "$SPARK_WORKLOAD" == "history" ]
then
  "${SPARK_HOME}/sbin"/start-history-server.sh
fi