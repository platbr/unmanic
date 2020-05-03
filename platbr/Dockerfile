FROM platbr/ffmpeg:hwaccel
LABEL maintainer="platbr <wagner.caixeta@gmail.com>"

COPY /requirements.txt /tmp/requirements.txt

RUN apt-get update && apt-get install -y python3 python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    pip3 install -r /tmp/requirements.txt

COPY ./platbr/s6-overlay-amd64.tar.gz /tmp/
RUN tar hzxf /tmp/s6-overlay-amd64.tar.gz -C / --exclude=usr/bin/execlineb && $_clean



COPY /docker/root   /
COPY /              /app/

ENV PS1="$(whoami)@$(hostname):$(pwd)$ "

### Environment variables
ENV \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_CTYPE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

ENTRYPOINT ["/init"]