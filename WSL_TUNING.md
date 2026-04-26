# WSL2 Performance Tuning

Provided for reference, your mileage may vary :-)

Optimized for host that has NVMe disks, 32 GB of RAM and 12 cores. Running Fedora instances in WSL.

```sh
# Windows 11
$ wsl --version
WSL version: 2.6.1.0
Kernel version: 6.6.87.2-1
WSLg version: 1.0.66
MSRDC version: 1.2.6353
Direct3D version: 1.611.1-81528511
DXCore version: 10.0.26100.1-240331-1435.ge-release
Windows version: 10.0.26200.8246
```

## WSL Config

In Windows:

```sh
# file ~/.wslconfig
[wsl2]
memory=16GB
processors=10
swap=8GB
swapFile=D:\\wsl\\swap.vhdx
kernelCommandLine=mitigations=off nvme_core.default_ps_max_latency_us=0 scsi_mod.scan=async cgroup_no_v1=all elevator=none quiet loglevel=0 audit=0

[experimental]
autoMemoryReclaim=gradual
autoDiskShrink=true
networkingMode=mirrored
dnsTunneling=true
```

In Linux:

```sh
# File: /etc/wsl.conf
[boot]
systemd=true

[user]
default=developer

[automount]
enabled=true
options="ro,uid=1000,gid=1000,umask=022,fmask=111"

[interop]
enabled=true
appendWindowsPath=false
```

## Performance tuning

In Linux for `journal`:

```sh
# File: /etc/systemd/journald.conf.d/wsl-limit.conf
[Journal]
SystemMaxUse=100M
RuntimeMaxUse=50M

$ sudo systemctl daemon-reload
```

In Linux for `sysctl`:

```sh
# File: /etc/sysctl.d/99-wsl-performance.conf
# --- Memory & Swap ---
vm.swappiness=40
vm.vfs_cache_pressure=50

# --- File I/O Optimization ---
vm.dirty_background_ratio=3
vm.dirty_ratio=10

# --- Filesystem Watchers ---
fs.inotify.max_user_watches=524288
fs.inotify.max_user_instances=8192

# --- Network Optimization ---
net.ipv4.tcp_tw_reuse=1
net.core.somaxconn=65535

# Increase ephemeral port range to prevent port exhaustion during heavy concurrent network pulls (Docker, NPM, Cargo)
net.ipv4.ip_local_port_range=1024 65535
# Expand read/write buffers for the Mirrored Network hypervisor bridge.
net.core.rmem_max=2500000
net.core.wmem_max=2500000
```

In Linux for `disks`:

```sh
# /etc/systemd/system/wsl-root-optimize.service
[Unit]
Description=Optimize WSL2 Ext4 Root Mount
DefaultDependencies=no
After=local-fs.target

[Service]
Type=oneshot
# Remount the root filesystem with our optimized IO parameters
ExecStart=/bin/mount -o remount,rw,noatime,nodiratime,commit=60,discard,errors=remount-ro,data=ordered /dev/sdd /

[Install]
WantedBy=multi-user.target

$ sudo systemctl enable wsl-root-optimize.service
```

## Advanced Kernel optimization

Consider running custom kernel that enables zram and zswap amongst other things: [xanmod-kernel-WSL2](https://github.com/Locietta/xanmod-kernel-WSL2)
