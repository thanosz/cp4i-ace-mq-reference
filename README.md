# cp4i-ace-mq-reference
Creates a TLS-enabled quemanager hosting an ACE.QUEUE for use with the included ACE application (replacement of IntegrationServer's LOCAL queue), an MTLS.QUEUE to demonstrate mutual TLS authentication, an STLS.QUEUE (one way tls) to demonstrate TLS enabled clients connections providing specific username.

Creates an IntegrationRuntime with a simple HTTP call that also adds a message to ACE.QUEUE

# Steps
##### 1. Create a new project, or switch to the project
`oc new-project qmtest` 

##### 2. Create the queuemanager. See [here](queuemanager/README.md) for details. The relevant certificates, keys, keystores, and yaml files are located under work
`pushd queuemanager; ./cp4i-mq-test.sh`

##### 3. Verify up and running
`oc get all`

##### 4. Test mutual authentication with the provided configuration. You need MQ developer tools for this. Check the message appear in queuemanager in cp4i
`pushd work; echo TEST | /opt/mqm/samp/bin/amqsputc MTLS.QUEUE QUEUEMGR1`

##### 5. Go to the root of repository
`popd; popd`

##### 6. Create the appconnect configurations. The files will be placed under configurations folder
`utils/create-configurations.sh`

##### 7. Apply all configuration yaml files
`oc apply -f configurations/ace-config-policy-mq.yaml -f configurations/ace-server-conf.yaml -f configurations/bar-auth.yaml`

##### 8. Create the example ace flow bar file
`utils/create-bar.sh`

##### 9. Copy the generated bar file to a your/public server (manual action)

##### 10. Set username/password in `configuration-sources/bar-auth.txt` to download the bar file. No changes are required if the bar file can be downloaded anonymously (see [here](https://www.ibm.com/docs/en/app-connect/13.0?topic=types-barauth-type) for details). If you changed `configuration-sources/bar-auth.txt` rerun the following
`utils/create-configurations.sh; oc apply -f configurations/bar-auth.yaml`

##### 11. Replace barURL in `yamls/integration-runtime.yaml` (manual action)

##### 12. Apply the integration-runtime
`oc apply -f yamls/integration-runtime.yaml`

##### 13. Test the ACE flow. Check the queue from CP4I that includes a new message
`curl -k https://simple-demo-https-qmtest.<CLUSTER_DOMAIN>/hello`

## Baking images
##### 14. For baking images, use the supplied Dockerfile to build and push the image to your registry
`docker build --build-arg ACETAG=13.0.2.2-r2-20250315-121329 --build-arg PROJECT=simple-demo -t <registry>/<repo>/<image_name>:<tag> --push .`

##### 15. Replace image in `yamls/integration-runtime-bake.yaml` (manual action)

##### 16. Apply the cofiguration
`oc apply -f yamls/integration-runtime-bake.yaml`

