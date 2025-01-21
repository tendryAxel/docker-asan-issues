# Dockerfile basé sur Debian
FROM debian:latest

RUN apt-get -y update
RUN apt-get -y install bash curl vim
RUN apt-get -y install wget tmux
RUN apt-get -y install cmake git autoconf libtool gdb
RUN apt-get -y install build-essential
RUN apt-get -y install pkg-config

RUN apt-get install -y nmap python3
RUN apt-get install -y pip python3-paramiko
#RUN pip install paramiko

RUN wget https://github.com/wolfSSL/wolfssl/archive/refs/tags/v4.5.0-stable.tar.gz
# RUN wget https://github.com/wolfSSL/wolfssl/archive/refs/tags/v5.7.6-stable.tar.gz
RUN wget https://github.com/wolfSSL/wolfssh/archive/refs/tags/v1.4.6-stable.tar.gz

RUN tar -xf v4.5.0-stable.tar.gz

RUN cd wolfssl-4.5.0-stable/ && \
    ./autogen.sh && \
    ./configure --enable-ssh && \
    make

RUN cd wolfssl-4.5.0-stable/ && \
    make install && \
    ldconfig

RUN tar -xf v1.4.6-stable.tar.gz

RUN cd wolfssh-1.4.6-stable && ./autogen.sh
RUN cd wolfssh-1.4.6-stable/ && CFLAGS="-fsanitize=address -g -O0" ./configure --enable-sftp

RUN cd wolfssh-1.4.6-stable/ && \
    make

COPY ./run.sh /wolfssh-1.4.6-stable/run.sh
RUN chmod +X /wolfssh-1.4.6-stable/run.sh

WORKDIR /wolfssh-1.4.6-stable/

ADD ./code /wolfssh-1.4.6-stable/code

CMD bash -c "sh run.sh && clear && tmux"
