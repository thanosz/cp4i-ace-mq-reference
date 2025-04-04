# cp4i-ace-mq-reference
Creates a TLS-enabled quemanager to be used with the included ACE application (replacement of IntegrationServer's LOCAL queue). It hosts an ACE.QUEUE and an STLS.QUEUE (one way tls) with no authentication and an MTLS.QUEUE with mutual TLS authentication to demonstrate TLS enabled mq clients connections that are authenticated against cert's common name (CN=)

Creates an IntegrationRuntime with a simple HTTP call that adds a message to MTLS.QUEUE. The IntegrationRuntime is configured through [appconnect Configurations](https://www.ibm.com/docs/en/app-connect/13.0?topic=reference-configuration-types) to
1. use the remote queue through the `server.conf.yaml`'s `remoteDefaultQueueManager` setting, 
2. use the MQPolicy mq-policy and
3. use the corresponding certificate stores in KDB format that have been generated with `runmqakm`.

You can play arround by changing the mq-policy's parameters to use the different queues.

It is expected that `openssl`, `oc` and `runmqakm` utility from MQ's developers package is availbale on the system

# Steps
#### 1. Create a new project, or switch to the project
`oc new-project qmtest` 
		
#### 2. Create the queuemanager. See [here](queuemanager/README.md) for details. The relevant certificates, keys, keystores, and yaml files are located under work. Wait for the script ro finish. Ignore any errors.
`pushd queuemanager; ./cp4i-mq-test.sh`

#### 3. Verify up and running
`oc get all`

#### 4. Test mutual authentication with the provided configuration. You need MQ developer tools for this. Check that the message appears in queuemanager in cp4i
`pushd work; echo TEST | /opt/mqm/samp/bin/amqsputc MTLS.QUEUE QUEUEMGR1`

#### 5. Go to the root of repository
`popd; popd`

#### 6. Create the appconnect configurations. The files will be placed under configurations folder
`utils/create-configurations.sh`

#### 7. Apply the generated appconnect configuration yaml files
`for i in $(ls configurations); do oc apply -f configurations/$i; done`

#### 8. Create the example ace flow bar file
`utils/create-bar.sh`

#### 9. Copy the generated bar file to your/public server (manual action)

#### 10. Set username/password in `configuration-sources/bar-auth.txt` to download the bar file. No changes are required if the bar file can be downloaded anonymously (see [here](https://www.ibm.com/docs/en/app-connect/13.0?topic=types-barauth-type) for details). If you changed `configuration-sources/bar-auth.txt` rerun step 6 and 7

#### 11. Replace barURL in `yamls/integration-runtime.yaml` (manual action)

#### 12. Apply the integration-runtime
`oc apply -f yamls/integration-runtime.yaml`

#### 13. Test the ACE flow. Check the queue from CP4I that includes a new message
`curl -k https://simple-demo-https-qmtest.<CLUSTER_DOMAIN>/hello`

## Baking images
#### 14. If not using bar files and baking images is preferred, use the supplied Dockerfile to build and push the image to your registry
`docker build --build-arg ACETAG=13.0.2.2-r2-20250315-121329 --build-arg PROJECT=simple-demo -t <registry>/<repo>/<image_name>:<tag> --push .`

#### 15. Replace image in `yamls/integration-runtime-bake.yaml` (manual action)

##### 16. Apply the cofiguration
`oc apply -f yamls/integration-runtime-bake.yaml`

## mqclient image/pod
As a bonus you can build an mqclient image with the supplied Dockerfile under `utils/mqclient`. You can then run a pod to access the queuemanger from within the cluster. The supplied `amqsput-go` binary is the [go implementation](https://github.com/ibm-messaging/mq-golang) of `amqsput`  which gives you a little bit more verbosity
