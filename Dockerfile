# Use server image to build bar file
ARG ACETAG=13.0.2.2-r2-20250315-121329

FROM cp.icr.io/cp/appc/ace-server-prod:${ACETAG} AS ACEBUILD
ARG PROJECT=simple-demo
USER root

ADD . /
RUN export LICENSE=accept && \
    source /opt/ibm/ace-1*/server/bin/mqsiprofile && \
    rm /ace-projects/${PROJECT}/*policy* && \
    ibmint package --input-path /ace-projects --project ${PROJECT} --output-bar-file /tmp/${PROJECT}.bar && \
    ibmint deploy --input-bar-file /tmp/${PROJECT}.bar --output-work-directory /home/aceuser/ace-server/

FROM cp.icr.io/cp/appc/ace-server-prod:${ACETAG}
USER root
COPY --from=ACEBUILD /home/aceuser/ace-server/ /home/aceuser/ace-server/
RUN chown -R aceuser:aceuser /home/aceuser && chmod -R ugo+rwx /home/aceuser/
USER 1001
