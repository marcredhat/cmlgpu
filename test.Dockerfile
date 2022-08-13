# Dockerfile
# Specify an ML Runtime base image
FROM docker.repository.cloudera.com/cloudera/cdsw/ml-runtime-workbench-python3.9-cuda:2021.12.1-b17
# Install ImageAI and dependenices in the new image
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.0-1_all.deb && apt-key del 7fa2af80 && dpkg -e cuda-keyring_1.0-1_all.deb
RUN apt-get update --allow-insecure-repositories --allow-unauthenticated -y  && apt-get install -y --allow-unauthenticated curl gzip
# Upgrade packages in the base image
RUN apt-get update --allow-insecure-repositories --allow-unauthenticated -y && apt-get upgrade --allow-unauthenticated  -y && apt-get clean && rm -rf /var/lib/apt/lists/*
#Install Julia
RUN export J_VERSION=$(curl -s "https://api.github.com/repos/JuliaLang/julia/releases/latest" | grep -Po '"tag_name": "v\K[0-9.]+')
ENV JULIA_VERSION=$J_VERSION
RUN export J_M_VERSION=$(echo $JULIA_VERSION | grep -Po "^[0-9]+.[0-9]+")
ENV JULIA_MINOR_VERSION=$J_M_VERSION
RUN pip3 install sklearn tensorflow-gpu keras torch
# Override Runtime label and environment variables metadata
ENV ML_RUNTIME_EDITION="Marc GPU Workbench Edition" ML_RUNTIME_SHORT_VERSION="1" ML_RUNTIME_MAINTENANCE_VERSION="8" ML_RUNTIME_FULL_VERSION="1.8" ML_RUNTIME_DESCRIPTION="This runtime includes Julia"
LABEL com.cloudera.ml.runtime.edition=$ML_RUNTIME_EDITION com.cloudera.ml.runtime.full-version=$ML_RUNTIME_FULL_VERSION com.cloudera.ml.runtime.short-version=$ML_RUNTIME_SHORT_VERSION com.cloudera.ml.runtime.maintenance-version=$ML_RUNTIME_MAINTENANCE_VERSION com.cloudera.ml.runtime.description=$ML_RUNTIME_DESCRIPTION
