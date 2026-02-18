# Terraform Module for Libvirt

Terraform modules for managing KVM virtual machines through libvirt. Supports cloud-init, multiple NICs, SCSI/virtio volumes, UEFI, PXE boot, and various network modes.

## Requirements

| Name | Version |
|------|---------|
| Terraform | >= 1.6 |
| [dmacvicar/libvirt](https://registry.terraform.io/providers/dmacvicar/libvirt/latest) | 0.8.3 |

## Modules

| Module | Description |
|--------|-------------|
| [domain](#module-domain) | Create a virtual machine (libvirt domain) |
| [network](#module-network) | Create a libvirt virtual network |
| [pool](#module-pool) | Create a storage pool and import OS images |

---

## Provider Configuration

```hcl
terraform {
  required_version = ">= 1.6"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.3"
    }
  }
}

# Local connection
provider "libvirt" {
  uri = "qemu:///system"
}

# Remote connection via SSH
# provider "libvirt" {
#   uri = "qemu+ssh://root@YOUR_ADDRESS:YOUR_PORT/system?keyfile=/path/to/key&sshauth=privkey&no_verify=1"
# }
```

---

## Module: domain

Creates a libvirt domain (virtual machine) with disks, networking, cloud-init, and advanced options such as UEFI and XSLT XML transformation.

### Basic Usage

```hcl
module "vm" {
  source = "../../modules/domain"

  instance_name      = "my-vm"
  volume_pool        = "vms"
  base_volume_name   = "ubuntu-noble-20251206.img"
  base_volume_pool   = "images"
  vcpu               = 2
  memory_size        = 2
  rootfs_size        = 20

  cloudinit_config_file = "../../templates/cloudinit.yaml.tpl"
  network_config_file   = "../../templates/network-v2.yaml.tpl"

  network_config = [
    {
      network_name     = "default"
      interface_name   = "ens3"
      ipv4_address     = "192.168.122.10/24"
      ipv4_gateway     = "192.168.122.1"
      ipv4_nameservers = "8.8.8.8"
    }
  ]
}
```

### Variables

#### Instance

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `instance_name` | `string` | `null` | **(Required)** Unique name for the VM |
| `instance_domain` | `string` | `null` | Domain suffix appended to the hostname (e.g. `example.com`) |
| `instance_running` | `bool` | `true` | Whether the VM should be running after creation |
| `instance_autostart` | `bool` | `false` | Automatically start the VM when the host boots |

#### Compute

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `vcpu` | `number` | `2` | Number of virtual CPUs |
| `memory_size` | `number` | `2` | Amount of RAM in GiB |

#### Storage

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `volume_pool` | `string` | `null` | **(Required)** Storage pool where new volumes will be created |
| `rootfs_size` | `number` | `20` | Root disk size in GiB |
| `rootfs_scsi` | `bool` | `false` | Use SCSI bus for the root disk (if `false`, virtio is used) |
| `base_volume_name` | `string` | `null` | Name of the base image to use as a CoW backing store |
| `base_volume_pool` | `string` | `null` | Pool where the base image resides |
| `virtio_volume_sizes` | `list(number)` | `[]` | List of sizes (GiB) for additional virtio data disks |
| `scsi_volume_sizes` | `list(number)` | `[]` | List of sizes (GiB) for additional SCSI data disks |
| `iso_path` | `string` | `null` | Path to an ISO image to attach as a CD-ROM drive |

#### Boot

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `boot_device` | `list(string)` | `["hd","cdrom","network"]` | Boot device order |
| `use_uefi` | `bool` | `false` | Enable UEFI firmware |
| `uefi_firmware_code` | `string` | `/usr/share/OVMF/OVMF_CODE.fd` | Path to the OVMF firmware code file |
| `uefi_firmware_vars` | `string` | `/usr/share/OVMF/OVMF_VARS.fd` | Path to the OVMF firmware variables template |

#### Cloud-init

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `cloudinit_config_file` | `string` | `null` | Path to the cloud-init user-data template file |
| `network_config_file` | `string` | `null` | Path to the cloud-init network-config template file |
| `cloudinit_config` | `object` | `{}` | Structured cloud-init configuration (see below) |

**`cloudinit_config` structure:**

```hcl
cloudinit_config = {
  package_update             = true
  package_upgrade            = false
  package_reboot_if_required = false
  packages                   = ["curl", "vim"]
  timezone                   = "Asia/Jakarta"

  users = [
    {
      name                = "admin"
      shell               = "/bin/bash"
      sudo_config         = "ALL=(ALL) NOPASSWD:ALL"
      groups              = "users, admin"
      ssh_authorized_keys = ["ssh-rsa AAAA..."]
      hashed_password     = "$6$..."
    }
  ]

  ntp = {
    enabled    = true
    ntp_client = "systemd-timesyncd"
    allow      = ["127.0.0.1/32"]
    servers    = ["time.cloudflare.com"]
  }
}
```

#### Network

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `network_config` | `list(object)` | see below | Network interface configuration for the VM |

**`network_config` structure:**

```hcl
network_config = [
  # Standard Ethernet
  {
    interface_type   = "ethernet"           # default
    network_name     = "default"
    interface_name   = "ens3"
    mac_address      = "a2:01:2a:52:ff:5a"  # optional
    ipv4_address     = "192.168.122.10/24"
    ipv4_gateway     = "192.168.122.1"
    ipv4_nameservers = "8.8.8.8,8.8.4.4"
  },
  # Bond (LACP)
  {
    interface_type  = "bond"
    interface_name  = "bond0"
    bond_interfaces = ["ens4", "ens5"]
    bond_mode       = "802.3ad"
    bond_miimon     = 100
    bond_lacp_rate  = "fast"
    ipv4_address    = "192.168.122.20/24"
  },
  # Bridge
  {
    interface_type       = "bridge"
    interface_name       = "br0"
    bridge_interfaces    = ["ens6", "ens7"]
    bridge_stp           = true
    bridge_forward_delay = 4
    ipv4_address         = "192.168.122.30/24"
    ipv4_gateway         = "192.168.122.1"
    ipv4_nameservers     = "8.8.8.8"
  }
]
```

#### Graphics

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `graphics_type` | `string` | `"vnc"` | Display server type (`vnc` or `spice`) |
| `graphics_listen_address` | `string` | `"127.0.0.1"` | IP address the VNC/SPICE server listens on |

#### Advanced

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `xslt_config_path` | `string` | `null` | Path to an XSLT file for transforming the libvirt domain XML |

---

## Module: network

Creates a libvirt virtual network with support for DHCP, custom DNS records, static routes, and bridge mode.

### Basic Usage

```hcl
module "network" {
  source            = "../../modules/network"
  network_name      = "my-network"
  network_mode      = "nat"
  network_addresses = ["192.168.200.0/24"]
}
```

### Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `network_name` | `string` | `null` | **(Required)** Name of the network |
| `network_autostart` | `bool` | `true` | Automatically start the network when the host boots |
| `network_mode` | `string` | `"nat"` | Network mode: `nat`, `route`, `bridge`, or `none` |
| `network_addresses` | `list(string)` | `null` | List of CIDR addresses for the network |
| `network_dhcp` | `bool` | `true` | Enable DHCP on the network |
| `network_mtu` | `number` | `1500` | MTU size for the network interface |
| `network_bridge` | `string` | `null` | Bridge device name (required when `network_mode = "bridge"`) |
| `network_domain` | `string` | `null` | DNS domain name for the network |
| `network_dns` | `object` | `null` | DNS configuration (see below) |
| `network_routes` | `list(object)` | `null` | Additional static routes |

**`network_dns` structure:**

```hcl
network_dns = {
  enabled    = true
  local_only = true
  hosts = [
    { hostname = "gateway", ip = "192.168.200.1" }
  ]
}
```

**`network_routes` structure:**

```hcl
network_routes = [
  { cidr = "10.0.0.0/8", gateway = "192.168.200.1" }
]
```

---

## Module: pool

Creates a libvirt storage pool and/or imports an OS image into it.

### Basic Usage

```hcl
module "pool" {
  source       = "../../modules/pool"
  pool_name    = "images"
  pool_path    = "/data/images"
  image_name   = "ubuntu-noble.img"
  image_source = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
}
```

### Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `pool_name` | `string` | `null` | **(Required)** Name of the storage pool |
| `pool_path` | `string` | `null` | Filesystem path for the pool directory (if `null`, pool is not created) |
| `image_name` | `string` | `null` | Name of the image volume inside the pool |
| `image_source` | `string` | `null` | URL or local path of the image to import (if `null`, no image is imported) |

---

## Examples

### Minimal VM (from a base image)

```hcl
module "vm_minimal" {
  source = "../../modules/domain"

  instance_name         = "vm-minimal"
  volume_pool           = "vms"
  base_volume_name      = "ubuntu-noble-20251206.img"
  base_volume_pool      = "images"
  vcpu                  = 2
  memory_size           = 2
  rootfs_size           = 20
  cloudinit_config_file = "../../templates/cloudinit.yaml.tpl"
  network_config_file   = "../../templates/network-v2.yaml.tpl"

  network_config = [
    {
      network_name     = "default"
      interface_name   = "ens3"
      ipv4_address     = "192.168.122.11/24"
      ipv4_gateway     = "192.168.122.1"
      ipv4_nameservers = "8.8.8.8"
    }
  ]
}
```

### PXE Boot VM

```hcl
module "vm_pxe" {
  source = "../../modules/domain"

  instance_name = "vm-pxe"
  volume_pool   = "vms"
  boot_device   = ["network", "hd"]
  vcpu          = 2
  memory_size   = 4
  rootfs_size   = 40

  network_config = [
    {
      network_name = "default"
      mac_address  = "a2:01:2a:52:ff:4a"
    }
  ]
}
```

### Boot from ISO

```hcl
module "vm_iso" {
  source = "../../modules/domain"

  instance_name = "vm-iso"
  iso_path      = "/data/isos/ubuntu-22.04.3-live-server-amd64.iso"
  volume_pool   = "vms"
  vcpu          = 2
  memory_size   = 4
  rootfs_size   = 40
  boot_device   = ["cdrom", "hd"]

  network_config = [
    { network_name = "default" }
  ]
}
```

### Storage Pools and Image Import

```hcl
# Create a pool only
module "pool_isos" {
  source    = "../../modules/pool"
  pool_name = "isos"
  pool_path = "/data/isos"
}

# Create a pool and import an image from a URL
module "pool_rocky" {
  source       = "../../modules/pool"
  pool_name    = "rocky"
  pool_path    = "/data/rocky"
  image_name   = "rocky-linux-10.1.qcow2"
  image_source = "https://dl.rockylinux.org/pub/rocky/10/images/x86_64/Rocky-10-GenericCloud-Base.latest.x86_64.qcow2"
}

# Import an image into an existing pool
module "import_ubuntu" {
  source       = "../../modules/pool"
  pool_name    = "images"
  image_name   = "ubuntu-jammy-20260119.img"
  image_source = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
}
```

### NAT and Route Networks

```hcl
module "net_nat" {
  source            = "../../modules/network"
  network_name      = "net-nat"
  network_mode      = "nat"
  network_addresses = ["192.188.0.0/24"]
  network_dhcp      = true
}

module "net_route" {
  source            = "../../modules/network"
  network_name      = "net-route"
  network_mode      = "route"
  network_addresses = ["192.187.0.0/24"]
  network_dhcp      = true
  network_domain    = "example.local"
  network_dns = {
    enabled    = true
    local_only = true
    hosts = [
      { hostname = "gateway", ip = "192.187.0.1" }
    ]
  }
  network_routes = [
    { cidr = "10.0.0.0/8", gateway = "192.187.0.1" }
  ]
}
```

---

## Directory Structure

```
.
├── modules/
│   ├── domain/          # VM module (libvirt domain)
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── volumes.tf
│   │   ├── cloudinit.tf
│   │   ├── locals.tf
│   │   └── providers.tf
│   ├── network/         # Virtual network module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── providers.tf
│   └── pool/            # Storage pool & image module
│       ├── main.tf
│       ├── variables.tf
│       └── providers.tf
├── templates/
│   ├── cloudinit.yaml.tpl       # cloud-init user-data template
│   ├── cloudinit-ubuntu.yaml    # Ubuntu cloud-init example
│   ├── cloudinit-rhel.yaml      # RHEL cloud-init example
│   ├── network-v1.yaml.tpl      # network-config v1 template
│   ├── network-v2.yaml.tpl      # network-config v2 template
│   └── libvirt.xslt.tpl         # XSLT template for domain XML transformation
└── examples/
    ├── vm/              # domain module usage examples
    ├── networks/        # network module usage examples
    └── pools/           # pool module usage examples
```

## License

[LICENSE](LICENSE)
