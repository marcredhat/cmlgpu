# Custom runtime with GPUs on CML Private Cloud 1.3.4

Clean up existing images; the instructions below **delete all images** , make sure this is what you want

```
#podman rmi $(podman images -qa) -f
#podman system prune --all --force && podman rmi --all
```
<br>

Let's **create a custom CML runtime** based on docker.repository.cloudera.com/cloudera/cdsw/ml-runtime-workbench-python3.9-cuda:2021.12.1-b17

In the Dockerfile below, note that:
- we also install install **sklearn, tensorflow-gpu, keras and torch**
- we specify ENV ML_RUNTIME_EDITION="Marc GPU Workbench Edition" which is the name that will be displayed in CML

<br>

```
 cat cdsw-julia.dockerfile
# Dockerfile
# Specify an ML Runtime base image
FROM docker.repository.cloudera.com/cloudera/cdsw/ml-runtime-workbench-python3.9-cuda:2021.12.1-b17
# Install ImageAI and dependenices in the new image
RUN apt-get update && apt-get install curl gzip
# Upgrade packages in the base image
RUN apt-get update -y && apt-get upgrade -y && apt-get clean && rm -rf /var/lib/apt/lists/*
#Install Julia
RUN export J_VERSION=$(curl -s "https://api.github.com/repos/JuliaLang/julia/releases/latest" | grep -Po '"tag_name": "v\K[0-9.]+')
ENV JULIA_VERSION=$J_VERSION
RUN export J_M_VERSION=$(echo $JULIA_VERSION | grep -Po "^[0-9]+.[0-9]+")
ENV JULIA_MINOR_VERSION=$J_M_VERSION
RUN pip3 install sklearn tensorflow-gpu keras torch
# Override Runtime label and environment variables metadata
ENV ML_RUNTIME_EDITION="Marc GPU Workbench Edition" ML_RUNTIME_SHORT_VERSION="1" ML_RUNTIME_MAINTENANCE_VERSION="8" ML_RUNTIME_FULL_VERSION="1.8" ML_RUNTIME_DESCRIPTION="This runtime includes Julia"
LABEL com.cloudera.ml.runtime.edition=$ML_RUNTIME_EDITION com.cloudera.ml.runtime.full-version=$ML_RUNTIME_FULL_VERSION com.cloudera.ml.runtime.short-version=$ML_RUNTIME_SHORT_VERSION com.cloudera.ml.runtime.maintenance-version=$ML_RUNTIME_MAINTENANCE_VERSION com.cloudera.ml.runtime.description=$ML_RUNTIME_DESCRIPTION
```

<br>
Let's **build an image using the above Dockerfile and push it to a repository**.

```
export TMPDIR="/home/tmp/buildah"
buildah bud cdsw-julia.dockerfile
podman images
podman push 68f9494a07c docker-sandbox.infra.cloudera.com/mchisinevski/marcgpu:0.2
```

<br>

At Site Administration / Runtime / Engine
**ensure that Maximum GPUs per Session/Job is at least 1**

![This is an image](images/setmaxgpus.png)

<br>

**Add our custom runtime to the Runtime Catalog**

![This is an image](images/addcustomruntimetoruntimecatalog.png)

<br>

**Check that our custom runtime is available in the Runtime Catalog**

![This is an image](images/checkcustomruntimeincatalog.png)

<br>

**Add the custom runtime to a CML project**

![This is an image](images/addcustomruntimetoproject.png)

<br>

**Check that the custom runtime is available to the CML project**

![This is an image](images/checkcustomruntimeisavailabletoproject.png)

<br>

**Specify the number of GPUs required and start a CML session**

![This is an image](images/startsession-specifygpu.png)

<br>

**CML session:**

![This is an image](images/session.png)

<br>

Click on "Terminal access" then **use Tensorflow to list the GPUs available to our CML session/pod**

![This is an image](images/tensorflowlistgpusfrompod.png)

<br>

**Use the view-allocations kubectl plugin**

```
kubectl view-allocations | grep gpu -A 12
```

<br>

![This is an image](images/viewgpuallocations.png)
