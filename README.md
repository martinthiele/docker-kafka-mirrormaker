# Docker Kafka MirrorMaker
Docker container that runs Kafka's MirrorMaker.

Kafka Version: 0.9.0.0 (Update Dockerfile for your Kafka Version)

## Usage
[The MirrorMaker documentation says](https://cwiki.apache.org/confluence/pages/viewpage.action?pageId=27846330):

> Setting up a mirror is easy - simply start up the mirror-maker processes after bringing up the target cluster. At minimum, the mirror maker takes one or more consumer configurations, a producer configuration and either a whitelist or a blacklist. You need to point the consumer to the source cluster's ZooKeeper, and the producer to the mirror cluster's ZooKeeper (or use the broker.list parameter).

The container expects the following environment variables to be passed in:

* `CONSUMER_ZK_CONNECT` - Zookeeper connection string for source, including port and chroot.
* `DOWNSTREAM_BROKERS` - Brokers to receive mirrored messages
* `WHITE_LIST` - (optional) White list of topics, if used, do not use black list
* `CONSUMER_GROUP_ID` - (optional) Defaults to 1
* `STREAM_COUNT` - (optional) Defaults to 1
* `OFFSET_RESET` - (optional) One of `smallest` or `largest`. Defaults to `largest`

<!-- * `ABORT_ON_FAILURE` - (optional) Kill MirrorMaker on failure. Defaults to true.
* `OFFSET_COMMIT_INTERVAL` - (optional) Defaults to 60000 -->

## Build
`docker build -t eodgooch/kafka-mirrormaker .`

## Run
`docker run -e WHITE_LIST="topic" -e CONSUMER_ZK_CONNECT=localhost:2181/ -e DOWNSTREAM_BROKERS=127.0.0.1:9092 eodgooch/kafka-mirrormaker`

## Run On Mesos via Marathon
- Configure `marathon-config.json` with the appropriate env variables CPU and RAM depending on number of streams.

## Limitations
- Currently only supports a single consumer
- Does not support message handlers
- Does not support rebalancers

## MirrorMaker Documentation
https://cwiki.apache.org/confluence/pages/viewpage.action?pageId=27846330
