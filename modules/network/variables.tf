variable "network_name" {
    description = "The name of the libvirt network"
    type        = string
    default     = null
}

variable "network_autostart" {
    description = "Whether the network should start automatically on host boot"
    type        = bool
    default     = true
}

variable "network_mode" {
    description = "The network mode (e.g. nat, route, bridge, none)"
    type        = string
    default     = "nat"
}

variable "network_addresses" {
    description = "List of CIDR addresses for the network"
    type        = list(string)
    default     = null
}

variable "network_dhcp" {
    description = "Whether to enable DHCP on the network"
    type        = bool
    default     = true
}

variable "network_mtu" {
    description = "The MTU size for the network interface"
    type        = number
    default     = 1500
}

variable "network_bridge" {
    description = "The name of the bridge device to use for the network"
    type        = string
    default     = null
}

variable "network_domain" {
    description = "The DNS domain name for the network"
    type        = string
    default     = null
}

variable "network_dns" {
    description = "DNS configuration for the network"
    type        = object({
                  enabled       = optional(bool)
                  local_only    = optional(bool)
                  hosts         = optional(list(object({
                                  hostname  = string
                                  ip        = string
                  })))
    })
    default     = null
}

variable "network_routes" {
    description = "value"
    type        = list(object({
                  cidr      = string
                  gateway   = string
    }))
    default     = null
}
