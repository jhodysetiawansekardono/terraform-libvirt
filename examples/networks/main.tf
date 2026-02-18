module "net1921870" {
    source              = "../../modules/network"
    network_name        = "net-192.187.0"
    network_autostart   = true
    network_mode        = "route"
    network_addresses   = [ "192.187.0.0/24" ]
    network_mtu         = 1500
    network_dhcp        = true
    network_domain      = "beruanglaut.cloud"
    network_dns         = {
        enabled         = true
        local_only      = true
        hosts           = [
            {
                hostname    = "gateway"
                ip          = "192.187.0.1"
            }
        ]
    }
    network_routes      = [
        {
            cidr    = "199.100.200.0/24"
            gateway = "192.187.0.1"
        },
        {
            cidr    = "199.200.200.0/24"
            gateway = "192.187.0.1"
        }
    ]
}

module "net1921880" {
    source              = "../../modules/network"
    network_name        = "net-192.188.0"
    network_autostart   = true
    network_mode        = "nat"
    network_addresses   = [ "192.188.0.0/24" ]
    network_mtu         = 1500
    network_dhcp        = true
}
