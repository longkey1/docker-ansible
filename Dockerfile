FROM debian:latest

# Fix frontend not set error
ARG DEBIAN_FRONTEND=noninteractive

# Install gosu
RUN apt-get -y update && apt-get -y install gosu

# Make working directory
ENV WORK_DIR=/work
RUN mkdir ${WORK_DIR}

# Set Entrypoint
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Install ansible
RUN apt-get -y install curl python
RUN cd /tmp && curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN cd /tmp && python get-pip.py
RUN pip install ansible
RUN ansible --version
