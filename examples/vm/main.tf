module "minimalist" {
    source                  = "../../modules/domain"
    instance_name           = "jh-minimalist"
    cloudinit_config_file   = "${path.module}/cloudinit-ubuntu.yaml"
    network_config_file     = "../../templates/network-v2.yaml"
    base_volume_name        = "ubuntu-noble-20251206.img"
    base_volume_pool        = "images"
    volume_pool             = "vms"
    vcpu                    = 4
    memory_size             = 8
    rootfs_size             = 20
    network_config          = [
        {
            network_name            = "default"
            interface_name          = "ens3"
            ipv4_address            = "192.168.122.11/24"
            ipv4_gateway            = "192.168.122.1"
            ipv4_nameservers        = "8.8.8.8"
        }
    ]
}

module "pxe_boot" {
    source                  = "../../modules/domain"
    instance_name           = "jh-pxe-boot"
    volume_pool             = "vms"
    boot_device             = [ "network", "hd" ]
    vcpu                    = 4
    memory_size             = 8
    rootfs_size             = 20
    network_config          = [
        {
            network_name            = "default"
            mac_address             = "a2:01:2a:52:ff:4a"
        },
        {
            network_name            = "default"
        }
    ]
}

module "boot_from_iso" {
    source                  = "../../modules/domain"
    instance_name           = "jh-pxe-boot"
    iso_path                = "/data/isos/ubuntu-22.04.3-live-server-amd64.iso"
    volume_pool             = "vms"
    vcpu                    = 4
    memory_size             = 8
    rootfs_size             = 20
    network_config          = [
        {
            network_name            = "default"
        }
    ]
}

module "all_you_can_config" {
    source                  = "../../modules/domain"
    instance_name           = "jh-all-config"
    instance_domain         = "example.com"
    instance_running        = true
    instance_autostart      = false
    cloudinit_config_file   = "../../templates/cloudinit.yaml"
    network_config_file     = "../../templates/network-v2.yaml"
    xslt_config_path        = "../../templates/libvirt.xslt"
    use_uefi                = true
    base_volume_name        = "ubuntu-noble-20251206.img"
    base_volume_pool        = "images"
    iso_path                = "/data/isos/file.iso"
    volume_pool             = "vms"
    boot_device             = [ "hd", "cdrom", "network" ]
    vcpu                    = 4
    memory_size             = 8
    rootfs_size             = 20
    rootfs_scsi             = false
    virtio_volume_sizes     = [ 10, 20, 30 ]
    scsi_volume_sizes       = [ 5, 15, 25 ]
    cloudinit_config        = {
        package_update              = true
        package_upgrade             = false
        package_reboot_if_required  = false
        packages                    = [
            "apt-transport-https",
            "arping",
            "bash-completion",
        ]
        users                       = [
            {
                name                = "root"
                ssh_authorized_keys = [
                    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCxxwu9k9LJMTebMmcsXjgYN6cwetH9M3moDtma4YwBBMG2DaTHH/cd2Z5GHn6DLFPeuYaN8I7ua6I4fjbJmJMs69K8TmtN+BqjOXNYOtgT4C3J6khDThbN1CmOjp0s0/sWQcWA1lJtksoqnspI/hwAft6GxsnaEe5Grcjg8j3DYxfdXTJRxnHIu6titFsF2vcwPrcNcNRzF4uK0Z7ND4v/0i4Fs4tUitEGzd3dgtZBXVQgfe7mhFIo4kvHoVbUUyZ1h42+7TTzdfJzZ8u6FfeZ6lEbffKnC2lYuUi0YVvOD8m+cpqRRbzubZvGHtWZAIaFKXvm/20zG/cPKPBxq5MPnAB+8KL3QEMFXfXjWGU0N3VXZnF2H4AMTfhtCP4/6zmpVRJRrOAaolGHRsUKEtGisZQpNVS7BpbqYn4ZPoIjSt+Vasn55esRYrY5LMraDvLkfwzny2dGOcjHXVEgJQv7fyOOxSdrmwKYM2WoYPA0mDIfoOtS1cPq7+D7mJ3K/l8= beruanglaut",
                    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC58knd+3hLv76yWZEQJOfkV0a0+obvMUA2jHC7r5SSX1n55hQ9AwVgvwpNEk4MJLHAXFfNZ2i2D9ij42FAMsYWVr7/k+gq0WENXdJZh6et4RFqeys2t224i/PXEY75f5yGrBteTX9wtPqrpdYdJ4yqCyNZ1idfm10i/Yezsgg5eBGwoSaBNn1nUaVoNKwXPqqcbY3qTavFDDOad6iGNwEG1mkczuf6IugjSpsRgiS/ZiL36cWXhtnr7XN/GZJyMZlkIsE8PiMnEBhQSJzTSHheioecN0qKQ5zmbRkolym2want620z4i4b/KP3x8z4dqhMa6v00K4hqERs4aI1+rldPeNA/ge9ODs4fUkt1DJlJ0z6/0QuB9VcwxUNLeVRc7JptDnVOeAwPniO8ZfaorHTGG0BY2HXeF2+pZGnMEquSIDrSH/5Nf2jWJBpbY5tB2DvPIwwFnPbNetTzA7MopxKRglODgMb4SNl/ZV4ZLcRXX1beX1JIdXcQ1pjj8mzjY0= root@hzn-fsn1-sd-bms-lab-01",
                ]
                hashed_password     = "$6$rounds=4096$j6KQqYfcR1hPLY0e$Gyv0uhMYa7JTBtybDjyrchMGgsaGe5PK752QcjZR1YilvKpVSeXVGA0/c87lIzJ3BWj1EIUqXkrCz4guj99vp0"
            },
            {
                name                = "beruanglaut"
                shell               = "/bin/bash"
                sudo_config         = "ALL=(ALL) NOPASSWD:ALL"
                groups              = "users, admin"
                ssh_authorized_keys = [
                    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCxxwu9k9LJMTebMmcsXjgYN6cwetH9M3moDtma4YwBBMG2DaTHH/cd2Z5GHn6DLFPeuYaN8I7ua6I4fjbJmJMs69K8TmtN+BqjOXNYOtgT4C3J6khDThbN1CmOjp0s0/sWQcWA1lJtksoqnspI/hwAft6GxsnaEe5Grcjg8j3DYxfdXTJRxnHIu6titFsF2vcwPrcNcNRzF4uK0Z7ND4v/0i4Fs4tUitEGzd3dgtZBXVQgfe7mhFIo4kvHoVbUUyZ1h42+7TTzdfJzZ8u6FfeZ6lEbffKnC2lYuUi0YVvOD8m+cpqRRbzubZvGHtWZAIaFKXvm/20zG/cPKPBxq5MPnAB+8KL3QEMFXfXjWGU0N3VXZnF2H4AMTfhtCP4/6zmpVRJRrOAaolGHRsUKEtGisZQpNVS7BpbqYn4ZPoIjSt+Vasn55esRYrY5LMraDvLkfwzny2dGOcjHXVEgJQv7fyOOxSdrmwKYM2WoYPA0mDIfoOtS1cPq7+D7mJ3K/l8= beruanglaut",
                    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC58knd+3hLv76yWZEQJOfkV0a0+obvMUA2jHC7r5SSX1n55hQ9AwVgvwpNEk4MJLHAXFfNZ2i2D9ij42FAMsYWVr7/k+gq0WENXdJZh6et4RFqeys2t224i/PXEY75f5yGrBteTX9wtPqrpdYdJ4yqCyNZ1idfm10i/Yezsgg5eBGwoSaBNn1nUaVoNKwXPqqcbY3qTavFDDOad6iGNwEG1mkczuf6IugjSpsRgiS/ZiL36cWXhtnr7XN/GZJyMZlkIsE8PiMnEBhQSJzTSHheioecN0qKQ5zmbRkolym2want620z4i4b/KP3x8z4dqhMa6v00K4hqERs4aI1+rldPeNA/ge9ODs4fUkt1DJlJ0z6/0QuB9VcwxUNLeVRc7JptDnVOeAwPniO8ZfaorHTGG0BY2HXeF2+pZGnMEquSIDrSH/5Nf2jWJBpbY5tB2DvPIwwFnPbNetTzA7MopxKRglODgMb4SNl/ZV4ZLcRXX1beX1JIdXcQ1pjj8mzjY0= root@hzn-fsn1-sd-bms-lab-01",
                ]
                hashed_password     = "$6$rounds=4096$j6KQqYfcR1hPLY0e$Gyv0uhMYa7JTBtybDjyrchMGgsaGe5PK752QcjZR1YilvKpVSeXVGA0/c87lIzJ3BWj1EIUqXkrCz4guj99vp0"
            }
        ]
        ntp                         = {
            enabled                 = true
            ntp_client              = "systemd-timesyncd"
            allow                   = [ "127.0.0.1/32" ]
            servers                 = [ "time.cloudflare.com" ]
        }
        timezone                    = "Asia/Jakarta"
    }
    network_config          = [
        {
            network_name            = "default"
            interface_name          = "ens3"
            mac_address             = "a2:01:2a:52:ff:5a"
            ipv4_address            = "192.168.122.11/24"
        },
        {
            network_name            = "default"
            interface_name          = "ens4"
            mac_address             = "a2:01:2a:52:ff:5b"
            ipv4_address            = "192.168.122.12/24"
        },
        {
            network_name            = "default"
            interface_name          = "ens5"
            mac_address             = "a2:01:2a:52:ff:5c"
        },
        {
            network_name            = "default"
            interface_name          = "ens6"
            mac_address             = "a2:01:2a:52:ff:5d"
        },
        {
            interface_type          = "bond"
            interface_name          = "bondm"
            bond_interfaces         = [ "ens5", "ens6" ]
            bond_mode               = "802.3ad"
            bond_miimon             = 100
            bond_lacp_rate          = "fast"
            ipv4_address            = "192.168.122.98/24"
        },
        {
            network_name            = "default"
            interface_name          = "ens7"
            mac_address             = "a2:01:2a:52:ff:5e"
        },
        {
            network_name            = "default"
            interface_name          = "ens8"
            mac_address             = "a2:01:2a:52:ff:5f"
        },
        {
            interface_type          = "bridge"
            interface_name          = "br0"
            bridge_interfaces       = [ "ens7", "ens8" ]
            bridge_stp              = true
            bridge_forward_delay    = 4
            ipv4_address            = "192.168.122.99/24"
            ipv4_gateway            = "192.168.122.1"
            ipv4_nameservers        = "8.8.8.8"
        }
    ]
    graphics_type           = "vnc"
    graphics_listen_address = "127.0.0.1"
}
