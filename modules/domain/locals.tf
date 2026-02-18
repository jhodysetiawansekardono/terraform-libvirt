locals {
    gib                 = 1024 * 1024 * 1024
    letters             = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
    virtio_start_index  = var.rootfs_scsi ? 0 : 1
    scsi_start_index    = var.rootfs_scsi ? 1 : 0
    virtio_volumes      = {
        for idx, size in var.virtio_volume_sizes :
        format("vd%s", local.letters[idx + local.virtio_start_index]) => size
    }
    scsi_volumes        = {
        for idx, size in var.scsi_volume_sizes :
        format("sd%s", local.letters[idx + local.scsi_start_index]) => size
    }
    scsi_device_count   = length(var.scsi_volume_sizes) + (var.rootfs_scsi ? 1 : 0)
    scsi_device_list    = flatten(
        [
            for idx in range(local.scsi_device_count) : [
                "-set",
                "device.scsi0-0-0-${idx}.rotation_rate=1",
            ]
        ]
    )
}
