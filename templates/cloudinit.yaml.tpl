#cloud-config
fqdn: ${hostname}${domain}
hostname: ${hostname}
create_hostname_file: true

%{ if config.package_update != null ~}
# Update & install package
package_update: ${config.package_update}
%{ endif ~}
%{ if config.package_update != null ~}
package_upgrade: ${config.package_upgrade}
%{ endif ~}
%{ if config.package_reboot_if_required != null ~}
package_reboot_if_required: ${config.package_reboot_if_required}
%{ endif ~}
%{ if config.packages != null ~}
packages:
%{ for pkg in config.packages ~}
  - ${pkg}
%{ endfor ~}
%{ endif ~}

%{ if config.users != null ~}
# Setup users & SSH
users:
%{ for user in config.users ~}
  - name: ${user.name}
%{ if user.shell != null ~}
    shell: ${user.shell}
%{ endif ~}
%{ if user.sudo_config != null ~}
    sudo: ${user.sudo_config}
%{ endif ~}
%{ if user.groups != null ~}
    groups: ${user.groups}
%{ endif ~}
%{ if user.hashed_password != null ~}
    passwd: ${user.hashed_password}
%{ endif ~}
%{ if user.ssh_authorized_keys != null ~}
    ssh_authorized_keys:
%{ for key in user.ssh_authorized_keys ~}
      - ${key}
%{ endfor ~}
%{ endif ~}
%{ endfor ~}
%{ endif ~}

%{ if config.users != null ~}
# Set user passwords on first boot
chpasswd:
  expire: false
  users:
%{ for user in config.users ~}
%{ if user.hashed_password != null ~}
    - name: ${user.name}
      password: ${user.hashed_password}
%{ endif ~}
%{ endfor ~}
%{ endif ~}

%{ if config.ntp != null ~}
# Set NTP
ntp:
  enabled: ${config.ntp.enabled}
  ntp_client: ${config.ntp.ntp_client}
  allow:
%{ for cidr in config.ntp.allow ~}
    - ${cidr}
%{ endfor ~}
  servers:
%{ for server in config.ntp.servers ~}
    - ${server}
%{ endfor ~}
%{ endif ~}
%{ if config.timezone != null ~}
timezone: ${config.timezone}
%{ endif ~}

# This message will be written in cloudinit.log
final_message: |
  cloud-init has finished
  version: $version
  timestamp: $timestamp
  datasource: $datasource
  uptime: $uptime
