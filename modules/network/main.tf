resource "libvirt_network" "network" {
    name        = var.network_name
    autostart   = var.network_autostart
    mode        = var.network_mode
    addresses   = var.network_addresses
    mtu         = var.network_mtu
    dhcp {
        enabled = var.network_dhcp
    }
    bridge      = var.network_mode == "bridge" ? var.network_bridge : null
    domain      = var.network_domain
    dynamic "dns" {
        for_each = var.network_dns != null ? [var.network_dns] : []
        content {
            enabled    = dns.value.enabled
            local_only = dns.value.local_only
            dynamic "hosts" {
                for_each = dns.value.hosts != null ? dns.value.hosts : []
                content {
                    hostname = hosts.value.hostname
                    ip       = hosts.value.ip
                }
            }
        }
    }
    dynamic "routes" {
        for_each = var.network_routes != null ? var.network_routes : []
        content {
            cidr    = routes.value.cidr
            gateway = routes.value.gateway
        }
    }
}
