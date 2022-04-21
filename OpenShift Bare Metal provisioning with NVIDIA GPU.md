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
