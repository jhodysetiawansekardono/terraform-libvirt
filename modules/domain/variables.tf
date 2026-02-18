variable "instance_name" {
  description = "(Required) The unique name for the libvirt domain (virtual machine instance). Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "instance_domain" {
  description = "(Optional) The domain suffix for the hostname (e.g., '.example.com'). When set, it will be appended to the instance name to form the FQDN."
  type        = string
  default     = null
}

variable "instance_running" {
  description = "(Optional) Whether the virtual machine should be running. When set to false, the VM will be stopped. Defaults to true."
  type        = bool
  default     = true
}

variable "instance_autostart" {
  description = "(Optional) Whether the virtual machine should automatically start when the host system boots. Defaults to false."
  type        = bool
  default     = false
}

variable "cloudinit_config_file" {
  description = "(Optional) The path to the cloud-init configuration file used to initialize the virtual machine."
  type        = string
  default     = null
}

variable "network_config_file" {
  description = "(Optional) The path to the network configuration file for the virtual machine."
  type        = string
  default     = null
}

variable "xslt_config_path" {
  description = "(Optional) path to the XSLT configuration file for transforming libvirt domain XML."
  type        = string
  default     = null
}

variable "use_uefi" {
  description = "(Optional) Enable UEFI firmware for the virtual machine"
  type        = bool
  default     = false
}

variable "uefi_firmware_code" {
  description = "(Optional) Path to UEFI firmware code file"
  type        = string
  default     = "/usr/share/OVMF/OVMF_CODE.fd"
}

variable "uefi_firmware_vars" {
  description = "(Optional) Path to UEFI firmware variables template file"
  type        = string
  default     = "/usr/share/OVMF/OVMF_VARS.fd"
}

variable "base_volume_name" {
  description = "(Optional) The name of the base volume to use as a backing store for copy-on-write (CoW) volumes."
  type        = string
  default     = null
}

variable "base_volume_pool" {
  description = "(Optional) The name of the libvirt storage pool containing the base volume."
  type        = string
  default     = null
}

variable "iso_path" {
  description = "(Optional) The path to the ISO image used to create a bootable CD-ROM drive."
  type        = string
  default     = null
}

variable "volume_pool" {
  description = "(Required) The name of the libvirt storage pool where new volumes will be created."
  type        = string
  default     = null
}

variable "boot_device" {
  description = "(Optional) The list of boot devices in order of preference. Valid values include 'hd', 'cdrom', 'network'."
  type        = list(string)
  default     = [ "hd", "cdrom", "network" ]
}

variable "vcpu" {
  description = "(Required) The number of virtual CPUs allocated to the virtual machine. Defaults to 2 if not specified."
  type        = number
  default     = 2
}

variable "memory_size" {
  description = "(Required) The amount of memory in GiB allocated to the virtual machine. Defaults to 2 if not specified."
  type        = number
  default     = 2
}

variable "rootfs_size" {
  description = "(Required) The size of the root filesystem volume in GiB. Defaults to 20 if not specified."
  type        = number
  default     = 20
}

variable "rootfs_scsi" {
  description = "(Optional) Whether to use SCSI bus for the root filesystem volume. If false, virtio bus will be used. Defaults to false."
  type        = bool
  default     = false
}

variable "virtio_volume_sizes" {
  description = "(Optional) List of sizes in GiB for additional virtio volumes to be created."
  type        = list(number)
  default     = []
}

variable "scsi_volume_sizes" {
  description = "(Optional) List of sizes in GiB for additional SCSI volumes to be created."
  type        = list(number)
  default     = []
}

variable "cloudinit_config" {
  description = "value"
  type        = object({
                package_update              = bool
                package_upgrade             = bool
                package_reboot_if_required  = bool
                packages                    = optional(list(string))
                users                       = optional(list(object({
                                              name                = string
                                              shell               = optional(string)
                                              sudo_config         = optional(string)
                                              groups              = optional(string)
                                              ssh_authorized_keys = optional(list(string))
                                              hashed_password     = optional(string)
                })))
                ntp                         = optional(object({
                                              enabled     = bool
                                              ntp_client  = string
                                              allow       = list(string)
                                              servers     = list(string)
                }))
                timezone                    = optional(string)
  })
  default     = {
                package_update              = null
                package_upgrade             = null
                package_reboot_if_required  = null
                packages                    = null
                users                       = null
                ntp                         = null
                timezone                    = null
  }
}

variable "network_config" {
  description = "(Optional) A list of networking configurations for the virtual machine, each containing network name, interface name, MAC address, IPv4 address, gateway, and nameservers."
  type        = list(object({
                interface_type        = optional(string, "ethernet")
                network_name          = optional(string)
                interface_name        = optional(string)
                mac_address           = optional(string)
                ipv4_address          = optional(string)
                ipv4_gateway          = optional(string)
                ipv4_nameservers      = optional(string)
                bridge_interfaces     = optional(list(string))
                bridge_stp            = optional(bool)
                bridge_forward_delay  = optional(number)
                bond_interfaces       = optional(list(string))
                bond_mode             = optional(string)
                bond_miimon           = optional(number)
                bond_lacp_rate        = optional(string)
                })
  )
  default = [
    {
      interface_type    = "ethernet"
      network_name      = null
      interface_name    = null
      mac_address       = null
      ipv4_address      = "192.168.122.100/24"
      ipv4_gateway      = "192.168.122.1"
      ipv4_nameservers  = "8.8.8.8,8.8.4.4"
    }
  ]
}

variable "graphics_type" {
  description = "(Optional) The type of graphics server to use for the virtual machine. Valid options are 'vnc' and 'spice'. Defaults to 'vnc'."
  type        = string
  default     = "vnc"
}

variable "graphics_listen_address" {
  description = "(Optional) The IP address on which the graphics server (e.g., VNC) will listen for connections. Defaults to '127.0.0.1' (localhost)."
  type        = string
  default     = "127.0.0.1"
}
