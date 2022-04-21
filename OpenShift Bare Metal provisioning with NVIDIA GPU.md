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

# Test the GPU in one nvidia-device-plugin-daemonset

```
oc exec -it   nvidia-device-plugin-daemonset-67mj8 -n gpu-operator-resources -- nvidia-smi
Defaulted container "nvidia-device-plugin-ctr" out of: nvidia-device-plugin-ctr, toolkit-validation (init)
Thu Apr 21 03:38:35 2022
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 470.57.02    Driver Version: 470.57.02    CUDA Version: 11.4     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Tesla P100-PCIE...  On   | 00000000:04:00.0 Off |                    0 |
| N/A   32C    P0    25W / 250W |      0MiB / 12198MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Tesla P100-PCIE...  On   | 00000000:82:00.0 Off |                    0 |
| N/A   35C    P0    26W / 250W |      0MiB / 12198MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+

+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|  No running processes found                                                 |
+-----------------------------------------------------------------------------+
```

# TensorFlow benchmarks with GPU

```
cat << EOF > tensorflow-benchmarks-gpu.yaml
apiVersion: v1
kind: Pod 
metadata:
 name: tensorflow-benchmarks-gpu
spec:
 containers:
 - image: nvcr.io/nvidia/tensorflow:19.09-py3
   name: cudnn
   command: ["/bin/sh","-c"]
   args: ["git clone https://github.com/tensorflow/benchmarks.git;cd benchmarks/scripts/tf_cnn_benchmarks;python3 tf_cnn_benchmarks.py --num_gpus=1 --data_format=NHWC --batch_size=32 --model=resnet50 --variable_update=parameter_server"]
   resources:
    limits:
      nvidia.com/gpu: 1
    requests:
      nvidia.com/gpu: 1
 restartPolicy: Never
EOF
```

```
oc create -f tensorflow-benchmarks-gpu.yaml
pod/tensorflow-benchmarks-gpu created
```

```
oc logs tensorflow-benchmarks-gpu
Cloning into 'benchmarks'...
2022-04-21 03:44:13.055593: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcudart.so.10.1
WARNING:tensorflow:From /usr/local/lib/python3.6/dist-packages/tensorflow/python/compat/v2_compat.py:61: disable_resource_variables (from tensorflow.python.ops.variable_scope) is deprecated and will be removed in a future version.
Instructions for updating:
non-resource variables are not supported in the long term
2022-04-21 03:44:16.259824: I tensorflow/core/platform/profile_utils/cpu_utils.cc:94] CPU Frequency: 2100005000 Hz
2022-04-21 03:44:16.265678: I tensorflow/compiler/xla/service/service.cc:168] XLA service 0x468dba0 executing computations on platform Host. Devices:
2022-04-21 03:44:16.265708: I tensorflow/compiler/xla/service/service.cc:175]   StreamExecutor device (0): <undefined>, <undefined>
2022-04-21 03:44:16.268132: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcuda.so.1
2022-04-21 03:44:16.518836: I tensorflow/compiler/xla/service/service.cc:168] XLA service 0x46a2780 executing computations on platform CUDA. Devices:
2022-04-21 03:44:16.518880: I tensorflow/compiler/xla/service/service.cc:175]   StreamExecutor device (0): Tesla P100-PCIE-12GB, Compute Capability 6.0
2022-04-21 03:44:16.520017: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1640] Found device 0 with properties:
name: Tesla P100-PCIE-12GB major: 6 minor: 0 memoryClockRate(GHz): 1.3285
pciBusID: 0000:82:00.0
2022-04-21 03:44:16.520075: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcudart.so.10.1
2022-04-21 03:44:16.522413: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcublas.so.10
2022-04-21 03:44:16.524734: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcufft.so.10
2022-04-21 03:44:16.525653: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcurand.so.10
2022-04-21 03:44:16.528056: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcusolver.so.10
2022-04-21 03:44:16.529370: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcusparse.so.10
2022-04-21 03:44:16.534400: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcudnn.so.7
2022-04-21 03:44:16.536188: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1763] Adding visible gpu devices: 0
2022-04-21 03:44:16.536233: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcudart.so.10.1
2022-04-21 03:44:16.883078: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1181] Device interconnect StreamExecutor with strength 1 edge matrix:
2022-04-21 03:44:16.883195: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1187]      0
2022-04-21 03:44:16.883218: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1200] 0:   N
2022-04-21 03:44:16.885308: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1326] Created TensorFlow device (/job:localhost/replica:0/task:0/device:GPU:0 with 11275 MB memory) -> physical GPU (device: 0, name: Tesla P100-PCIE-12GB, pci bus id: 0000:82:00.0, compute capability: 6.0)
WARNING:tensorflow:From /workspace/benchmarks/scripts/tf_cnn_benchmarks/convnet_builder.py:134: conv2d (from tensorflow.python.layers.convolutional) is deprecated and will be removed in a future version.
Instructions for updating:
Use `tf.keras.layers.Conv2D` instead.
W0421 03:44:16.916622 139636022495040 deprecation.py:323] From /workspace/benchmarks/scripts/tf_cnn_benchmarks/convnet_builder.py:134: conv2d (from tensorflow.python.layers.convolutional) is deprecated and will be removed in a future version.
Instructions for updating:
Use `tf.keras.layers.Conv2D` instead.
WARNING:tensorflow:From /workspace/benchmarks/scripts/tf_cnn_benchmarks/convnet_builder.py:266: max_pooling2d (from tensorflow.python.layers.pooling) is deprecated and will be removed in a future version.
Instructions for updating:
Use keras.layers.MaxPooling2D instead.
W0421 03:44:17.288227 139636022495040 deprecation.py:323] From /workspace/benchmarks/scripts/tf_cnn_benchmarks/convnet_builder.py:266: max_pooling2d (from tensorflow.python.layers.pooling) is deprecated and will be removed in a future version.
Instructions for updating:
Use keras.layers.MaxPooling2D instead.
WARNING:tensorflow:From /usr/local/lib/python3.6/dist-packages/tensorflow/python/ops/losses/losses_impl.py:121: add_dispatch_support.<locals>.wrapper (from tensorflow.python.ops.array_ops) is deprecated and will be removed in a future version.
Instructions for updating:
Use tf.where in 2.0, which has the same broadcast rule as np.where
W0421 03:44:19.779575 139636022495040 deprecation.py:323] From /usr/local/lib/python3.6/dist-packages/tensorflow/python/ops/losses/losses_impl.py:121: add_dispatch_support.<locals>.wrapper (from tensorflow.python.ops.array_ops) is deprecated and will be removed in a future version.
Instructions for updating:
Use tf.where in 2.0, which has the same broadcast rule as np.where
WARNING:tensorflow:From /workspace/benchmarks/scripts/tf_cnn_benchmarks/benchmark_cnn.py:2268: Supervisor.__init__ (from tensorflow.python.training.supervisor) is deprecated and will be removed in a future version.
Instructions for updating:
Please switch to tf.train.MonitoredTrainingSession
W0421 03:44:21.107485 139636022495040 deprecation.py:323] From /workspace/benchmarks/scripts/tf_cnn_benchmarks/benchmark_cnn.py:2268: Supervisor.__init__ (from tensorflow.python.training.supervisor) is deprecated and will be removed in a future version.
Instructions for updating:
Please switch to tf.train.MonitoredTrainingSession
2022-04-21 03:44:21.567565: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1640] Found device 0 with properties:
name: Tesla P100-PCIE-12GB major: 6 minor: 0 memoryClockRate(GHz): 1.3285
pciBusID: 0000:82:00.0
2022-04-21 03:44:21.567664: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcudart.so.10.1
2022-04-21 03:44:21.567787: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcublas.so.10
2022-04-21 03:44:21.567833: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcufft.so.10
2022-04-21 03:44:21.567866: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcurand.so.10
2022-04-21 03:44:21.567901: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcusolver.so.10
2022-04-21 03:44:21.567936: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcusparse.so.10
2022-04-21 03:44:21.567972: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcudnn.so.7
2022-04-21 03:44:21.569652: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1763] Adding visible gpu devices: 0
2022-04-21 03:44:21.569750: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1181] Device interconnect StreamExecutor with strength 1 edge matrix:
2022-04-21 03:44:21.569778: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1187]      0
2022-04-21 03:44:21.569784: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1200] 0:   N
2022-04-21 03:44:21.571428: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1326] Created TensorFlow device (/job:localhost/replica:0/task:0/device:GPU:0 with 11275 MB memory) -> physical GPU (device: 0, name: Tesla P100-PCIE-12GB, pci bus id: 0000:82:00.0, compute capability: 6.0)
2022-04-21 03:44:22.141431: W tensorflow/compiler/jit/mark_for_compilation_pass.cc:1412] (One-time warning): Not using XLA:CPU for cluster because envvar TF_XLA_FLAGS=--tf_xla_cpu_global_jit was not set.  If you want XLA:CPU, either set that envvar, or use experimental_jit_scope to enable XLA:CPU.  To confirm that XLA is active, pass --vmodule=xla_compilation_cache=1 (as a proper command-line flag, not via TF_XLA_FLAGS) or set the envvar XLA_FLAGS=--xla_hlo_profile.
INFO:tensorflow:Running local_init_op.
I0421 03:44:22.353680 139636022495040 session_manager.py:500] Running local_init_op.
INFO:tensorflow:Done running local_init_op.
I0421 03:44:22.414918 139636022495040 session_manager.py:502] Done running local_init_op.
2022-04-21 03:44:23.995757: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcublas.so.10
2022-04-21 03:44:24.181447: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcudnn.so.7
TensorFlow:  1.14
Model:       resnet50
Dataset:     imagenet (synthetic)
Mode:        training
SingleSess:  False
Batch size:  32 global
             32 per device
Num batches: 100
Num epochs:  0.00
Devices:     ['/gpu:0']
NUMA bind:   False
Data format: NHWC
Optimizer:   sgd
Variables:   parameter_server
==========
Generating training model
Initializing graph
Running warm up
Done warm up
Step	Img/sec	total_loss
1	images/sec: 180.2 +/- 0.0 (jitter = 0.0)	8.108
10	images/sec: 181.0 +/- 0.1 (jitter = 0.2)	8.122
20	images/sec: 180.6 +/- 0.1 (jitter = 0.4)	7.983
30	images/sec: 180.2 +/- 0.3 (jitter = 0.8)	7.780
40	images/sec: 180.2 +/- 0.2 (jitter = 0.8)	7.848
50	images/sec: 180.2 +/- 0.2 (jitter = 0.7)	7.779
60	images/sec: 180.2 +/- 0.1 (jitter = 0.5)	7.824
70	images/sec: 180.2 +/- 0.2 (jitter = 0.5)	7.838
80	images/sec: 180.2 +/- 0.2 (jitter = 0.5)	7.818
90	images/sec: 180.3 +/- 0.1 (jitter = 0.5)	7.647
100	images/sec: 180.4 +/- 0.1 (jitter = 0.5)	7.915
----------------------------------------------------------------
total images/sec: 180.26
----------------------------------------------------------------
```
```
