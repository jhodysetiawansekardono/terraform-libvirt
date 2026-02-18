version: 2
%{ if length([for net in networking : net if try(net.interface_type, "ethernet") == "ethernet"]) > 0 ~}
ethernets:
%{ for net in networking ~}
%{ if try(net.interface_type, "ethernet") == "ethernet" ~}
  ${net.interface_name}:
%{ if try(net.mac_address, null) != null ~}
    match:
      macaddress: "${net.mac_address}"
    set-name: ${net.interface_name}
%{ endif ~}
%{ if try(net.ipv4_address, null) != null ~}
    addresses:
      - ${net.ipv4_address}
%{ else ~}
    addresses: []
%{ endif ~}
%{ if try(net.ipv4_gateway, null) != null ~}
    routes:
      - to: default
        via: ${net.ipv4_gateway}
%{ endif ~}
%{ if try(net.ipv4_nameservers, null) != null ~}
    nameservers:
      addresses:
        - ${net.ipv4_nameservers}
%{ endif ~}
    dhcp4: false
    dhcp6: false
%{ endif ~}
%{ endfor ~}
%{ endif ~}
%{ if length([for net in networking : net if try(net.interface_type, "") == "bond"]) > 0 ~}
bonds:
%{ for net in networking ~}
%{ if try(net.interface_type, "") == "bond" ~}
  ${net.interface_name}:
    interfaces:
%{ for iface in net.bond_interfaces ~}
      - ${iface}
%{ endfor ~}
    parameters:
      mode: ${try(net.bond_mode, "active-backup")}
%{ if try(net.bond_miimon, null) != null ~}
      mii-monitor-interval: ${net.bond_miimon}
%{ endif ~}
%{ if try(net.bond_lacp_rate, null) != null ~}
      lacp-rate: ${net.bond_lacp_rate}
%{ endif ~}
%{ if try(net.ipv4_address, null) != null ~}
    addresses:
      - ${net.ipv4_address}
%{ else ~}
    addresses: []
%{ endif ~}
%{ if try(net.ipv4_gateway, null) != null ~}
    routes:
      - to: default
        via: ${net.ipv4_gateway}
%{ endif ~}
%{ if try(net.ipv4_nameservers, null) != null ~}
    nameservers:
      addresses:
        - ${net.ipv4_nameservers}
%{ endif ~}
    dhcp4: false
    dhcp6: false
%{ endif ~}
%{ endfor ~}
%{ endif ~}
%{ if length([for net in networking : net if try(net.interface_type, "") == "bridge"]) > 0 ~}
bridges:
%{ for net in networking ~}
%{ if try(net.interface_type, "") == "bridge" ~}
  ${net.interface_name}:
    interfaces:
%{ for iface in net.bridge_interfaces ~}
      - ${iface}
%{ endfor ~}
%{ if try(net.bridge_stp, null) != null ~}
    parameters:
      stp: ${net.bridge_stp}
%{ if try(net.bridge_forward_delay, null) != null ~}
      forward-delay: ${net.bridge_forward_delay}
%{ endif ~}
%{ endif ~}
%{ if try(net.ipv4_address, null) != null ~}
    addresses:
      - ${net.ipv4_address}
%{ else ~}
    addresses: []
%{ endif ~}
%{ if try(net.ipv4_gateway, null) != null ~}
    routes:
      - to: default
        via: ${net.ipv4_gateway}
%{ endif ~}
%{ if try(net.ipv4_nameservers, null) != null ~}
    nameservers:
      addresses:
        - ${net.ipv4_nameservers}
%{ endif ~}
    dhcp4: false
    dhcp6: false
%{ endif ~}
%{ endfor ~}
%{ endif ~}
