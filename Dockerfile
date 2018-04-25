FROM mycluster.icp:8500/default/iib-prod:10.0.0.10 

MAINTAINER Timur Markunin timur.markunin1@ibm.com

#begin here

# Install packages

USER root

RUN apt-get update && \
    apt-get install -y rpm

RUN rm -rf /var/lib/apt/lists/*

#Install MQ client libraries

ARG MQ_URL=http://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/messaging/mqadv/mqadv_dev903_linux_x86-64.tar.gz
ARG MQ_PACKAGES="MQSeriesRuntime-*.rpm MQSeriesClient-*.rpm MQSeriesSamples-*.rpm"

RUN mkdir -p /tmp/mq \
  	&& cd /tmp/mq \
  	&& curl -LO $MQ_URL \
	&& tar -zxvf ./*.tar.gz \
	&& cd /tmp/mq/MQServer \
# Install MQ using the RPM packages
	# Accept the MQ license
  	&& ./mqlicense.sh -text_only -accept \
  	&& rpm -ivh --force-debian $MQ_PACKAGES \
# Clean up all the downloaded files
  	&& rm -rf /tmp/mq \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /var/mqm 
	
COPY *.bar  /etc/
	
USER iibuser
