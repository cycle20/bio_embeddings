# This location of python in venv-build needs to match the location in the runtime image,
# so we're manually installing the required python environment
FROM ubuntu:20.04 AS venv-build

# build-essential is for jsonnet
RUN apt-get update && \
    apt-get install -y curl build-essential python3 python3-pip python3-distutils python3-venv python3-dev python3-virtualenv git

WORKDIR /app

RUN python3 -m venv .venv && \
    # Install a recent version of pip, otherwise the installation of manylinux2010 packages will fail
    .venv/bin/pip install -U pip
RUN .venv/bin/pip install tensorboard && \
    .venv/bin/pip install bio-embeddings[all]

FROM nvidia/cuda:11.4.3-runtime-ubuntu20.04

ENV PYTHONUNBUFFERED=1

RUN apt-get update \
    && apt-get install -y python3 python3-distutils \
    && rm -rf /var/lib/apt/lists/*

# # Workaround for when switching the docker user
# # https://github.com/numba/numba/issues/4032#issuecomment-547088606
RUN mkdir /tmp/numba_cache && chmod 777 /tmp/numba_cache
ENV NUMBA_CACHE_DIR=/tmp/numba_cache

RUN mkdir /tmp/matplotlib && chmod 777 /tmp/matplotlib
ENV MPLCONFIGDIR=/tmp/matplotlib

COPY --from=venv-build /app/.venv /venv
# COPY . /app/

#RUN mkdir -p /.cache/bio_embeddings && chmod -R a+w /.cache/
ENV TRANSFORMERS_CACHE=/.cache
WORKDIR /app

#ENTRYPOINT ["/venv/bin/python", "-m", "bio_embeddings.utilities.cli"]
ENTRYPOINT [ "/bin/bash", "/app/bioemb.sh" ]
