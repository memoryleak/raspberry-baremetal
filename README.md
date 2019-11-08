# raspberry-baremetal
## Folders
* blob - binary files required for the RPi3b+ to boot.
* dist - tftp/SD-card output to boot from
* build - intermediate build files
* src - actual source code

### Blobs
#### start.elf
Firmware that is loaded on to the VideoCore in the SoC, which then takes over the boot process.

#### fixup.dat
Causes the memory to be reported correctly and allows proper access.


## Building
`make`

## Booting
In order to boot the new build image copy the contents of dist/ onto a SD-Card, or use PXE/TFTP to boot over network.

### dnsmasq configuration for network boot
Raspbery devices is plugged directly into the server (my desktop running Fedora 30):

	user=dnsmasq
	group=dnsmasq
	interface=enp4s0
	dhcp-range=192.168.200.50,192.168.200.150,12h
	dhcp-host=0c:9d:92:85:e4:ab,192.168.200.1
	dhcp-boot=pxelinux,192.168.200.1
	enable-tftp
	tftp-root=[PATH-TO-REPO]/dist
	log-queries
	log-dhcp
	conf-dir=/etc/dnsmasq.d,.rpmnew,.rpmsave,.rpmorig

	sudo dnsmasq --no-daemon --log-queries --log-facility=/var/log/dnsmasq.log

