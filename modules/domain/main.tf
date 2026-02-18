resource "libvirt_domain" "virtual_machines" {
    name        = var.instance_name
    running     = var.instance_running
    autostart   = var.instance_autostart
    memory      = 1024 * var.memory_size
    vcpu        = var.vcpu

    cpu {
        mode = "host-passthrough"
    }

    firmware = var.use_uefi ? var.uefi_firmware_code : null
    dynamic "nvram" {
        for_each = var.use_uefi ? [1] : []
        content {
            file      = "/var/lib/libvirt/qemu/nvram/${var.instance_name}_VARS.fd"
            template  = var.uefi_firmware_vars
        }
    }

    cloudinit = length(libvirt_cloudinit_disk.cloudinit) > 0 ? libvirt_cloudinit_disk.cloudinit[0].id : null

    console {
        type        = "pty"
        target_port = "0"
        target_type = "serial"
    }

    console {
        type        = "pty"
        target_port = "1"
        target_type = "virtio"
    }

    disk {
        volume_id = length(libvirt_volume.rootfs_volume) > 0 ? libvirt_volume.rootfs_volume[0].id : libvirt_volume.rootfs_volume_base[0].id
        scsi      = var.rootfs_scsi
    }

    dynamic "disk" {
        for_each = var.iso_path != "" && var.iso_path != null ? [var.iso_path] : []
        content {
            file = disk.value
        }
    }

    dynamic "disk" {
        for_each = libvirt_volume.virtio_volumes
        content {
            volume_id = disk.value.id
        }
    }

    dynamic "disk" {
        for_each = libvirt_volume.scsi_volumes
        content {
            volume_id = disk.value.id
            scsi      = "true"
        }
    }

    dynamic "xml" {
        for_each = var.xslt_config_path != null ? [1] : []
        content {
          xslt = templatefile(
            var.xslt_config_path,
            {
                scsi_device_list = local.scsi_device_list
            }
          )
        }
    }

    boot_device {
        dev = var.boot_device
    }

    dynamic "network_interface" {
        for_each = {
            for idx, net in var.network_config :
            idx => net
            if net.network_name != null
        }
        content {
            network_name  = network_interface.value.network_name
            mac           = network_interface.value.mac_address != null ? network_interface.value.mac_address : null
        }
    }

    video {
        type = "vga"
    }

    graphics {
        type            = var.graphics_type
        listen_type     = "address"
        listen_address  = var.graphics_listen_address
        autoport        = true
    }
}
