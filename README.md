# cmlgpu

```
#podman rmi $(podman images -qa) -f
#podman system prune --all --force && podman rmi --all
export TMPDIR="/home/tmp/buildah"
buildah bud cdsw-julia.dockerfile
podman images
podman push 68f9494a07c docker-sandbox.infra.cloudera.com/mchisinevski/marcgpu:0.2
```


![This is an image](images/setmaxgpus.png)


![This is an image](images/addcustomruntimetoruntimecatalog.png)


![This is an image](images/checkcustomruntimeincatalog.png)


![This is an image](images/addcustomruntimetoproject.png)


![This is an image](images/checkcustomruntimeisavailabletoproject.png)

![This is an image](images/startsession-specifygpu.png)

![This is an image](images/session.png)


![This is an image](images/tensorflowlistgpusfrompod.png)

![This is an image](images/view-allocations-kubectl-plugin.png)

![This is an image](images/viewgpuallocations.png)
