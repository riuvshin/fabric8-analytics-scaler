FROM registry.centos.org/centos/centos:7
MAINTAINER Tomas Hrcka <thrcka@redhat.com>

ENV LANG=en_US.UTF-8

RUN yum --setopt=tsflags=nodocs install -y epel-release centos-release-openshift-origin36 && \
    yum --setopt=tsflags=nodocs install -y python34-pip wget python34-devel libxml2-devel libxslt-devel python34-requests python34-pycurl origin-clients && \
    yum clean all

COPY requirements.txt /tmp/
RUN pip3 install --upgrade pip && pip install --upgrade wheel && \
    pip3 install -r /tmp/requirements.txt

RUN mkdir -p /home/scaler/ /var/lib/f8a-scaler/

RUN echo 1 > /var/lib/f8a-scaler/liveness && \
    echo 0 > /var/lib/f8a-scaler/liveness_prev && \
    chmod 666 /var/lib/f8a-scaler/liveness /var/lib/f8a-scaler/liveness_prev

COPY scale.sh sqs_status.py liveness_check.sh /home/scaler/

WORKDIR /home/scaler

CMD bash scale.sh
