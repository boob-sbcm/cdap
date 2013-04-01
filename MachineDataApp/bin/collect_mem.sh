#!/bin/bash

#
# Sends random Memory metrics
#

if [ $# -ne 1 ]; then
	echo "Required argument: <num_metrics>"
	exit
fi

num_metrics=$1

# Set pointers to URL endpoint
GATEWAY_HOSTNAME=${GATEWAY_HOSTNAME:=localhost}
GATEWAY_REST_BASE_URL=${GATEWAY_REST_BASE_URL:=http://${GATEWAY_HOSTNAME}:10000/stream/}
STREAM_NAME=${STREAM_NAME:=memStatsStream}
GATEWAY_STREAM_URL=${GATEWAY_STREAM_URL:=$GATEWAY_REST_BASE_URL$STREAM_NAME}

# Generate random cpu spikes
for (( i=0; i<$num_metrics; i++ )); do
    mem=$RANDOM
    mem=$((mem*1000))
    timestamp=`date +%s`
    timestamp=$((timestamp*1000)) # normalize to milliseconds 
	metric=$timestamp", "$mem", "$HOSTNAME
    echo "Inserting action: $metric to $GATEWAY_STREAM_URL"
	curl  "$GATEWAY_STREAM_URL" --data "$metric"
	sleep 1
done
