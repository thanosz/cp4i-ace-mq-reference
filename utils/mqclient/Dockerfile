FROM ubuntu
RUN apt -y update && apt -y install vim wget
RUN mkdir /opt/mqm /mqclient
WORKDIR /mqclient
RUN wget https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/messaging/mqdev/redist/9.4.2.0-IBM-MQC-Redist-LinuxX64.tar.gz && \
        tar -xf 9.4.2.0-IBM-MQC-Redist-LinuxX64.tar.gz -C /opt/mqm/ && \
        rm 9.4.2.0-IBM-MQC-Redist-LinuxX64.tar.gz && \
        ln -s /opt/mqm/samp/bin/amqsput .
ADD amqsput-go ccdt.json mqclient.ini /mqclient
RUN export LD_LIBRARY_PATH=/opt/mqm/lib64
RUN useradd -m -s /bin/bash user1 && chown -R user1:user1 /mqclient
USER user1
