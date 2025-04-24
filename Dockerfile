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
RUN apt-get update && apt-get install -y curl gnupg
RUN curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | gpg --dearmor -o /usr/share/keyrings/cloudflare-main.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared any main" > /etc/apt/sources.list.d/cloudflared.list
RUN apt-get update && apt-get install -y cloudflared
RUN cloudflared version

