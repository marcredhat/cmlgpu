# OpenShift Bare Metal provisioning with NVIDIA GPU

<br>

https://egallen.com/openshift-baremetal-gpu/

https://access.redhat.com/documentation/en-us/openshift_container_platform/4.8/html/installing/deploying-installer-provisioned-clusters-on-bare-metal


# Checks

## Node entitlement

```
oc get machineconfig | grep entitlement
50-entitlement-key-pem                                                                        2.2.0             243d
50-entitlement-pem                                                                            2.2.0             243d
```

```
oc debug node/worker-014
Starting pod/worker-014-debug ...
To use host binaries, run `chroot /host`
Pod IP: 10.17.131.41
If you don't see a command prompt, try pressing enter.
sh-4.4#
sh-4.4# chroot /host
sh-4.4# ls -la /etc/rhsm/rhsm.conf /etc/pki/entitlement/entitlement.pem /etc/pki/entitlement/entitlement-key.pem
-rw-r--r--. 1 root root 43042 Jan 28 15:28 /etc/pki/entitlement/entitlement-key.pem
-rw-r--r--. 1 root root 43042 Jan 28 15:28 /etc/pki/entitlement/entitlement.pem
-rw-r--r--. 1 root root  2851 Jan 28 15:28 /etc/rhsm/rhsm.conf
```

```
curl -O https://raw.githubusercontent.com/openshift-psap/blog-artifacts/master/how-to-use-entitled-builds-with-ubi/0004-cluster-wide-entitled-pod.yaml

oc create -f 0004-cluster-wide-entitled-pod.yaml
 
oc logs cluster-entitled-build-pod
```

# Check that Node feature discovery is installed and that we can find additionnal tags for each node

```
oc describe node/worker-014 | grep gpu
                    nvidia.com/gpu.compute.major=6
                    nvidia.com/gpu.compute.minor=0
                    nvidia.com/gpu.count=2
                    nvidia.com/gpu.deploy.container-toolkit=true
                    nvidia.com/gpu.deploy.dcgm=true
                    nvidia.com/gpu.deploy.dcgm-exporter=true
                    nvidia.com/gpu.deploy.device-plugin=true
                    nvidia.com/gpu.deploy.driver=true
                    nvidia.com/gpu.deploy.gpu-feature-discovery=true
                    nvidia.com/gpu.deploy.node-status-exporter=true
                    nvidia.com/gpu.deploy.operator-validator=true
                    nvidia.com/gpu.family=pascal
                    nvidia.com/gpu.machine=PowerEdge-R730
                    nvidia.com/gpu.memory=12198
                    nvidia.com/gpu.present=true
                    nvidia.com/gpu.product=Tesla-P100-PCIE-12GB
```

```
oc describe node/worker-014 | grep pci
                    feature.node.kubernetes.io/pci-102b.present=true
                    feature.node.kubernetes.io/pci-10de.present=true
                    feature.node.kubernetes.io/pci-14e4.present=true
                    feature.node.kubernetes.io/pci-8086.present=true
                    feature.node.kubernetes.io/pci-8086.sriov.capable=true
```

