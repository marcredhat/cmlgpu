FROM docker.repository.cloudera.com/cloudera/cdsw/ml-runtime-workbench-python3.7-standard:2022.11.1-b2

RUN apt-get update && apt-get install curl gzip

RUN apt-get update -y && apt-get upgrade -y && apt-get clean && rm -rf /var/lib/apt/lists/*
#Install Julia
RUN export J_VERSION=$(curl -s "https://api.github.com/repos/JuliaLang/julia/releases/latest" | grep -Po '"tag_name": "v\K[0-9.]+')
ENV JULIA_VERSION=$J_VERSION
RUN export J_M_VERSION=$(echo $JULIA_VERSION | grep -Po "^[0-9]+.[0-9]+")
ENV JULIA_MINOR_VERSION=$J_M_VERSION
RUN pip3 install scikit-learn tensorflow keras torch
# Override Runtime label and environment variables metadata
ENV ML_RUNTIME_EDITION="Marc GPU Workbench Edition" ML_RUNTIME_SHORT_VERSION="1" ML_RUNTIME_MAINTENANCE_VERSION="8" ML_RUNTIME_FULL_VERSION="1.8" ML_RUNTIME_DESCRIPTION="This runtime includes Julia"
LABEL com.cloudera.ml.runtime.edition=$ML_RUNTIME_EDITION com.cloudera.ml.runtime.full-version=$ML_RUNTIME_FULL_VERSION com.cloudera.ml.runtime.short-version=$ML_RUNTIME_SHORT_VERSION com.cloudera.ml.runtime.maintenance-version=$ML_RUNTIME_MAINTENANCE_VERSION com.cloudera.ml.runtime.description=$ML_RUNTIME_DESCRIPTION
