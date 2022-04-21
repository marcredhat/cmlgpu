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

# Check that the NVIDIA GPU Operator is installed and that all its pods are running

```
oc get pods -n  gpu-operator-resources
NAME                                       READY   STATUS      RESTARTS   AGE
gpu-feature-discovery-4wf55                1/1     Running     0          82d
gpu-feature-discovery-6bfmw                1/1     Running     0          82d
gpu-feature-discovery-j8462                1/1     Running     0          82d
gpu-feature-discovery-mqvt9                1/1     Running     0          82d
gpu-feature-discovery-x8r8l                1/1     Running     0          82d
gpu-feature-discovery-xpkt7                1/1     Running     0          82d
nvidia-container-toolkit-daemonset-55trn   1/1     Running     0          82d
nvidia-container-toolkit-daemonset-bx7hr   1/1     Running     0          82d
nvidia-container-toolkit-daemonset-npnsz   1/1     Running     0          82d
nvidia-container-toolkit-daemonset-ssccc   1/1     Running     0          82d
nvidia-container-toolkit-daemonset-vd6hf   1/1     Running     0          82d
nvidia-container-toolkit-daemonset-vvkm6   1/1     Running     0          82d
nvidia-cuda-validator-4rqhf                0/1     Completed   0          82d
nvidia-cuda-validator-b9jgm                0/1     Completed   0          82d
nvidia-cuda-validator-ml4zl                0/1     Completed   0          82d
nvidia-cuda-validator-mld8q                0/1     Completed   0          82d
nvidia-cuda-validator-n9bnd                0/1     Completed   0          82d
nvidia-cuda-validator-w5pdw                0/1     Completed   0          82d
nvidia-dcgm-5lhpv                          1/1     Running     0          82d
nvidia-dcgm-6dftx                          1/1     Running     0          82d
nvidia-dcgm-bldv7                          1/1     Running     0          82d
nvidia-dcgm-exporter-fdpwq                 1/1     Running     0          82d
nvidia-dcgm-exporter-gsgzw                 1/1     Running     0          82d
nvidia-dcgm-exporter-h47gh                 1/1     Running     0          82d
nvidia-dcgm-exporter-kkxf5                 1/1     Running     0          82d
nvidia-dcgm-exporter-ngslr                 1/1     Running     0          82d
nvidia-dcgm-exporter-pzjlg                 1/1     Running     0          82d
nvidia-dcgm-hg25h                          1/1     Running     0          82d
nvidia-dcgm-mlpxl                          1/1     Running     0          82d
nvidia-dcgm-qwq5k                          1/1     Running     0          82d
nvidia-device-plugin-daemonset-67mj8       1/1     Running     0          82d
nvidia-device-plugin-daemonset-6nd8r       1/1     Running     0          82d
nvidia-device-plugin-daemonset-bw8b5       1/1     Running     0          82d
nvidia-device-plugin-daemonset-hfnzq       1/1     Running     0          82d
nvidia-device-plugin-daemonset-qfrqs       1/1     Running     0          82d
nvidia-device-plugin-daemonset-s5np4       1/1     Running     0          82d
nvidia-device-plugin-validator-4qrzr       0/1     Completed   0          82d
nvidia-device-plugin-validator-9zjx7       0/1     Completed   0          82d
nvidia-device-plugin-validator-kn6w6       0/1     Completed   0          82d
nvidia-device-plugin-validator-lfwhx       0/1     Completed   0          82d
nvidia-device-plugin-validator-tkq72       0/1     Completed   0          82d
nvidia-device-plugin-validator-xvl5f       0/1     Completed   0          82d
nvidia-driver-daemonset-jhkhv              1/1     Running     0          82d
nvidia-driver-daemonset-k8w6f              1/1     Running     0          82d
nvidia-driver-daemonset-k9vwn              1/1     Running     0          82d
nvidia-driver-daemonset-mlzkh              1/1     Running     0          82d
nvidia-driver-daemonset-qpt26              1/1     Running     0          82d
nvidia-driver-daemonset-s8l8s              1/1     Running     0          82d
nvidia-node-status-exporter-69kd7          1/1     Running     0          197d
nvidia-node-status-exporter-8bmw6          1/1     Running     0          197d
nvidia-node-status-exporter-9kmfl          1/1     Running     0          243d
nvidia-node-status-exporter-dfff6          1/1     Running     0          197d
nvidia-node-status-exporter-dkmvm          1/1     Running     0          197d
nvidia-node-status-exporter-qnhdg          1/1     Running     0          197d
nvidia-operator-validator-2glm5            1/1     Running     0          82d
nvidia-operator-validator-mfzts            1/1     Running     0          82d
nvidia-operator-validator-p77wn            1/1     Running     0          82d
nvidia-operator-validator-tggl5            1/1     Running     0          82d
nvidia-operator-validator-vhz7q            1/1     Running     0          82d
nvidia-operator-validator-wvm4r            1/1     Running     0          82d
```

# Check CUDA workload validation

```
oc logs nvidia-cuda-validator-4rqhf -n  gpu-operator-resources
cuda workload validation is successful
```

# Check device-plugin workload validation

```
oc logs nvidia-device-plugin-validator-4qrzr -n  gpu-operator-resources
device-plugin workload validation is successful
```

# Check all NVIDIA Operator validations

```
oc logs nvidia-operator-validator-wvm4r -n  gpu-operator-resources
all validations are successful
sh: line 1:     8 Terminated              sleep infinity
all validations are successful
```


