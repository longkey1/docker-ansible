FROM alpine:latest

# Install dependency packages
RUN apk add --update build-base libffi-dev python-dev openssl-dev openssh-client git py-pip

# Install ansible
RUN pip install --upgrade pip
RUN pip install ansible
