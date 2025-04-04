#!/usr/bin/env bash
pushd ace-projects/simple-demo

zip -r policy.zip mq-policy/
popd
mv ace-projects/simple-demo/policy.zip .

CONFIG_CONTENT_BASE64="$(base64 -i  policy.zip| tr -d '\n')"
sed "s|#REPLACE_ME#|${CONFIG_CONTENT_BASE64}|g" configurations-templates/ace-config-policy-mq-template.yaml > configurations/ace-config-policy-mq.yaml

DATA=$(cat configurations-sources/bar-auth.txt | base64 -w 0)
sed "s|#REPLACE_ME#|${DATA}|g" configurations-templates/bar-auth-template.yaml > configurations/bar-auth.yaml

DATA=$(cat configurations-sources/server.conf.yaml | base64 -w 0)
sed "s|#REPLACE_ME#|${DATA}|g" configurations-templates/ace-server-conf-template.yaml > configurations/ace-server-conf.yaml


DATA=$(cat queuemanager/work/qm-client.kdb | base64 -w 0)
sed "s|#REPLACE_ME#|${DATA}|g" configurations-templates/ace-config-mqclient-kdb.yaml > configurations/ace-config-mqclient-kdb.yaml

DATA=$(cat queuemanager/work/qm-client.rdb | base64 -w 0)
sed "s|#REPLACE_ME#|${DATA}|g" configurations-templates/ace-config-mqclient-rdb.yaml > configurations/ace-config-mqclient-rdb.yaml

DATA=$(cat queuemanager/work/qm-client.sth | base64 -w 0)
sed "s|#REPLACE_ME#|${DATA}|g" configurations-templates/ace-config-mqclient-sth.yaml > configurations/ace-config-mqclient-sth.yaml
