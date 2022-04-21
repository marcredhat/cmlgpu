
# Useful commands


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

