docker rmi acebuild
docker build --no-cache -f utils/Dockerfile.createbar --build-arg ACETAG=13.0.2.1-r1 -t acebuild .
docker run -d --rm --name acebuild --entrypoint /bin/bash acebuild -c "sleep 10"
sleep 2
docker cp acebuild:/tmp/simple-demo.bar .
