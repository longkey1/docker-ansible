# https://github.com/ansible-collections/community.digitalocean/issues/132#issuecomment-934355414
# https://packages.ubuntu.com/search?keywords=python3-resolvelib
FROM ubuntu:focal

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

# Confirm ansible version
RUN ansible --version

# Install community.general collection
RUN ansible-galaxy collection install community.general

# Confirm collection list
RUN ansible-galaxy collection list
