version: 1
config:
%{ for net in networking ~}
%{ if try(net.interface_type, "ethernet") == "ethernet" ~}
  - type: physical
    name: ${net.interface_name}
%{ if try(net.mac_address, null) != null ~}
    mac_address: "${net.mac_address}"
%{ endif ~}
%{ if try(net.ipv4_address, null) != null ~}
    subnets:
      - type: static
        address: ${net.ipv4_address}
%{ if try(net.ipv4_gateway, null) != null ~}
        gateway: ${net.ipv4_gateway}
%{ endif ~}
%{ if try(net.ipv4_nameservers, null) != null ~}
        dns_nameservers:
          - ${net.ipv4_nameservers}
%{ endif ~}
%{ endif ~}
%{ endif ~}
%{ if try(net.interface_type, "") == "bond" ~}
  - type: bond
    name: ${net.interface_name}
    bond_interfaces:
%{ for iface in net.bond_interfaces ~}
      - ${iface}
%{ endfor ~}
    params:
      bond-mode: ${try(net.bond_mode, "active-backup")}
%{ if try(net.bond_miimon, null) != null ~}
      bond-miimon: ${net.bond_miimon}
%{ endif ~}
%{ if try(net.bond_lacp_rate, null) != null ~}
      bond-lacp-rate: ${net.bond_lacp_rate}
%{ endif ~}
%{ if try(net.ipv4_address, null) != null ~}
    subnets:
      - type: static
        address: ${net.ipv4_address}
%{ if try(net.ipv4_gateway, null) != null ~}
        gateway: ${net.ipv4_gateway}
%{ endif ~}
%{ if try(net.ipv4_nameservers, null) != null ~}
        dns_nameservers:
          - ${net.ipv4_nameservers}
%{ endif ~}
%{ endif ~}
%{ endif ~}
%{ if try(net.interface_type, "") == "bridge" ~}
  - type: bridge
    name: ${net.interface_name}
    bridge_interfaces:
%{ for iface in net.bridge_interfaces ~}
      - ${iface}
%{ endfor ~}
%{ if try(net.bridge_stp, null) != null || try(net.bridge_forward_delay, null) != null ~}
    params:
%{ if try(net.bridge_stp, null) != null ~}
      bridge_stp: ${net.bridge_stp ? "on" : "off"}
%{ endif ~}
%{ if try(net.bridge_forward_delay, null) != null ~}
      bridge_fd: ${net.bridge_forward_delay}
%{ endif ~}
%{ endif ~}
%{ if try(net.ipv4_address, null) != null ~}
    subnets:
      - type: static
        address: ${net.ipv4_address}
%{ if try(net.ipv4_gateway, null) != null ~}
        gateway: ${net.ipv4_gateway}
%{ endif ~}
%{ if try(net.ipv4_nameservers, null) != null ~}
        dns_nameservers:
          - ${net.ipv4_nameservers}
%{ endif ~}
%{ endif ~}
%{ endif ~}
%{ endfor ~}
