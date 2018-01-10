DEFAULT_STREAMS=1
# DEFAULT_OFFSET_COMMIT_INTERVAL=60000
# DEFAULT_ABORT_ON_FAILURE="true"
DEFAULT_GROUP_ID="KafkaMirror"
DEFAULT_OFFSET_RESET="largest"

if [ -n "$WHITE_LIST" ]; then
    WHITE_LIST="--whitelist $WHITE_LIST"
fi

if [ -z "$STREAM_COUNT" ]; then
    STREAM_COUNT=$DEFAULT_STREAMS
fi

if [ -z "$OFFSET_RESET" ]; then
    echo "Using default offset reset of largest"
    OFFSET_RESET=$DEFAULT_OFFSET_RESET
fi

# if [ -z "$ABORT_ON_FAILURE" ]; then
#     ABORT_ON_FAILURE=DEFAULT_ABORT_ON_FAILURE
# fi

# if [ -z "$OFFSET_COMMIT_INTERVAL" ]; then
#     OFFSET_COMMIT_INTERVAL=DEFAULT_OFFSET_COMMIT_INTERVAL
# fi

if [ -z "$CONSUMER_GROUP_ID" ]; then
    CONSUMER_GROUP_ID=$DEFAULT_GROUP_ID
fi

if [ -z "$CONSUMER_ZK_CONNECT" ]; then
    echo "Specify CONSUMER_ZK_CONNECT connection string"
    exit 2
fi

if [ -z "$DOWNSTREAM_BROKERS" ]; then
    echo "Specify DOWNSTREAM_BROKERS"
    exit 3
fi


cat <<- EOF > ~/consumer.config
    zookeeper.connect=$CONSUMER_ZK_CONNECT
    group.id=$CONSUMER_GROUP_ID
    auto.offset.reset=$OFFSET_RESET
EOF


cat <<- EOF > ~/producer.config
    bootstrap.servers=$DOWNSTREAM_BROKERS
EOF

/bin/bash  /opt/kafka/bin/kafka-run-class.sh kafka.tools.MirrorMaker \
--consumer.config ~/consumer.config \
--producer.config ~/producer.config \
--num.streams $STREAM_COUNT \
$WHITE_LIST \
# --offset.commit.interval.ms $OFFSET_COMMIT_INTERVAL
# --abort.on.send.failure $ABORT_ON_FAILURE

# --consumer.rebalance.listener="TODO?"
# --rebalance.listener.args="TODO?"
# --message.handler="TODO?"
# --message.handler.args="TODO?"
