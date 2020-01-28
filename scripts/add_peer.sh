#!/usr/bin/env bash

sudo -i -u splunk ${SPLUNK_BIN} add search-server https://idx01:8089 -auth admin:${SPLUNK_PASS} -remoteUsername admin -remotePassword ${SPLUNK_PASS}
