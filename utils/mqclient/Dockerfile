FROM ubuntu
RUN apt -y update && apt -y install vim
RUN mkdir /opt/mqm

# get the MQ Linux libraries from https://ibm.biz/mq94redistclients
ADD 9.4.2.0-IBM-MQC-Redist-LinuxX64.tar.gz /opt/mqm

RUN mkdir /mqclient
ADD amqsput ccdt.json mqclient.ini /mq/
RUN export LD_LIBRARY_PATH=/opt/mqm/lib64
RUN useradd -m -s /bin/bash than && chown -R than:than /mq
WORKDIR /mqclient
CMD ["tail", "-f", "/dev/null"]
USER than
