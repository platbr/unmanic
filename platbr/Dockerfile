FROM platbr/ffmpeg:hwaccel
LABEL maintainer="platbr <wagner.caixeta@gmail.com>"

# Add pip requirements
COPY /requirements.txt /tmp/requirements.txt

### Install pyinotify service.
RUN apt-get update && apt-get install -y python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install -r /tmp/requirements.txt

### Add local files
COPY /docker/root   /
COPY /              /app/


### Environment variables
ENV \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_CTYPE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

