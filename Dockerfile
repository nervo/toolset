FROM quay.io/ssbarnea/python:3.8-slim-buster
# Image above is just a mirror of ^ docker.io/python:3.8-slim-buster which we
# had to manually create because at this moment quay.io has mirroring disabled
# and our builds were randomly failing due to docker pull limiting us.
# see https://pythonspeed.com/articles/base-image-python-docker-images/
LABEL maintainer="Ansible <info@ansible.com>"

ENV PACKAGES="\
bash \
docker.io \
git \
gcc \
rsync \
libyaml-dev \
"

ENV PIP_INSTALL_ARGS="--pre"
ENV PYTHONDONTWRITEBYTECODE=1

RUN \
apt update && \
apt install -y ${PACKAGES} && \
apt-get autoclean

COPY requirements.txt /tmp/requirements.txt

RUN \
python3 -m pip install \
${PIP_INSTALL_ARGS} -r /tmp/requirements.txt && \
rm -rf /root/.cache && \
molecule --version && \
molecule drivers && \
python3 -m pip check && \
docker --version
# running cli commands adds a minimal level fail-safe protection
# against a broken image.

ENV SHELL /bin/bash
