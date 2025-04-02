#cp4i-ace-mq-reference


#####1. create a new project, or switch to the project
`oc new-project qmtest` 

#####2. create queuemanager Also see [here](queuemanager/README.md)
`pushd queuemanager; ./cp4i-mq-test.sh`

#####3. verify up and running
`oc get all`

#####4. test mutual authentication with the provided configuration. You need MQ developer tools for this. Check the message appear in queuemanager in cp4i
`pushd work; echo TEST | /opt/mqm/samp/bin/amqsputc MTLS.QUEUE QUEUEMGR1`

#####5. go to the root of repository
`popd; popd`

#####6. create the appconnect configurations. The files will be placed under configurations folder
`utils/create-configurations.sh`

#####7. apply all configuration yaml files
`oc apply -f configurations/ace-config-policy-mq.yaml -f configurations/ace-server-conf.yaml -f configurations/bar-auth.yaml`

#####8. create the example ace flow bar file
`utils/create-bar.sh`

#####9. copy the generated bar file to a public server

#####10. adjust configuration-sources/bar-auth.txt (leave as it is for no authentication). If you changed utils/create-configurations.sh rerun the following
`utils/create-configurations.sh; `
`oc apply -f configurations/bar-auth.yaml`


#####11. replace barURL in yamls/integration-runtime.yaml

#####12. apply the integration-runtime
`oc apply -f yamls/integration-runtime.yaml`

#####13. for bake images, use the supplied Dockerfile to build and push the image to your registry
`docker build -f Dockerfile.ace-server-build --build-arg ACETAG=13.0.2.2-r2-20250315-121329 -t <registry>/<repo>/<image_name>:<tag> --push .`

#####14. replace image in yamls/integration-runtime-bake.yaml

#####15. apply the cofiguration
`oc apply -f yamls/integration-runtime-bake.yaml`







