FROM ubuntu:latest

# Fix frontend not set error
ARG DEBIAN_FRONTEND=noninteractive

# Update apt packages
RUN apt-get -y update

# Install gosu
RUN apt-get -y install gosu

# Make working directory
ENV WORK_DIR=/work
RUN mkdir ${WORK_DIR}

# Set Entrypoint
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Install ansible
# https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-on-ubuntu
RUN apt-get -y install software-properties-common
RUN add-apt-repository --yes --update ppa:ansible/ansible
RUN apt-get -y install ansible
RUN ansible --version

# Install collections - community.general, ansible.posix
RUN ansible-galaxy collection install community.general
RUN ansible-galaxy collection install ansible.posix
RUN ansible-galaxy collection list

# Install cloudflared
RUN apt-get -y install wget
RUN wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb -o /tmp/cloudflared-linux-amd64.deb
RUN cd /tmp && apt-get -y install cloudflared-linux-amd64.deb
RUN cloudflared version
