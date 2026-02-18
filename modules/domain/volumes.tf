resource "libvirt_volume" "rootfs_volume" {
    count               = var.base_volume_name == null ? 1 : 0
    name                = format("%s-rootfs.qcow2", var.instance_name)
    size                = var.rootfs_size * local.gib
    pool                = var.volume_pool
    format              = "qcow2"
}

resource "libvirt_volume" "rootfs_volume_base" {
    count               = var.base_volume_name != null ? 1 : 0
    name                = format("%s-rootfs.qcow2", var.instance_name)
    size                = var.rootfs_size * local.gib
    pool                = var.volume_pool
    base_volume_name    = var.base_volume_name
    base_volume_pool    = var.base_volume_pool
    format              = "qcow2"
}

resource "libvirt_volume" "virtio_volumes" {
    for_each            = local.virtio_volumes
    name                = format("%s-%s.qcow2", var.instance_name, each.key)
    size                = each.value * local.gib
    pool                = var.volume_pool
    format              = "qcow2"
}

resource "libvirt_volume" "scsi_volumes" {
    for_each            = local.scsi_volumes
    name                = format("%s-%s.qcow2", var.instance_name, each.key)
    size                = each.value * local.gib
    pool                = var.volume_pool
    format              = "qcow2"
}
