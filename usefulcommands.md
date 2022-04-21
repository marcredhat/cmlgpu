
# Useful commands


```
oc debug node/worker-014
chroot /host
lspci -vvv  > /tmp/lspci.txt
```

Sample output: https://github.com/marcredhat/cmlgpu/blob/main/lspci.txt


If LnkSta (Link Status) is less than LnkCap (Link Capability), it will display (downgraded) next to the Width. 
This means that the PCI card is capable of more than what the PCI slot can provide.

```
oc debug node/worker-014
chroot /host
lspci -vvv  | grep downgraded
		LnkSta:	Speed unknown (downgraded), Width x0 (downgraded)
		LnkSta:	Speed 5GT/s (downgraded), Width x1 (downgraded)
		LnkSta:	Speed 5GT/s (downgraded), Width x1 (downgraded)
		LnkSta:	Speed 2.5GT/s (downgraded), Width x0 (downgraded)
		LnkSta:	Speed 2.5GT/s (downgraded), Width x0 (downgraded)
		LnkSta:	Speed 2.5GT/s (downgraded), Width x1 (ok)
		LnkSta:	Speed 5GT/s (ok), Width x1 (downgraded)
		LnkSta:	Speed 5GT/s (ok), Width x1 (downgraded)
		LnkSta:	Speed 5GT/s (ok), Width x1 (downgraded)
		LnkSta:	Speed 5GT/s (ok), Width x1 (downgraded)
pcilib: sysfs_read_vpd: read failed: Input/output error
		LnkSta:	Speed 8GT/s (ok), Width x4 (downgraded)
		LnkSta:	Speed 5GT/s (downgraded), Width x8 (ok)
		LnkSta:	Speed 8GT/s (ok), Width x4 (downgraded)
```


```
Step 1:Download this file from the paywall
curl -L https://archive.cloudera.com/ml-runtimes/latest/artifacts/repo-assembly.json -o repo-assembly.json

Step2: Extract the docker URLs
cat repo-assembly.json| jq -r '.runtimes[].image_identifier'

Step 3: Docker pull
for i in $(jq -r '.runtimes[].image_identifier' repo-assembly.json); do podman pull ${i}; done;

Step 4: Save to tar.gz
podman save $(jq -r '.runtimes[].image_identifier' repo-assembly.json) -o runtime-images.tgz

Step 5: Distribute to all nodes of the cluster
Copy the runtime-images.tgz file to all the CDSW nodes.

Step 6: Upload on all nodes of the cluster
podman load -i /tmp/runtime-images.tgz
```


