resource "libvirt_cloudinit_disk" "cloudinit" {
    count = (var.cloudinit_config_file != null || var.network_config_file != null) ? 1 : 0
    name           = "${var.instance_name}-cloudinit.iso"
    pool           = var.volume_pool
    user_data      = var.cloudinit_config_file != null ? templatefile(
        var.cloudinit_config_file,
        {
            hostname    = var.instance_name
            domain      = var.instance_domain != null ? ".${var.instance_domain}" : ""
            config      = var.cloudinit_config
        }
    ) : null
    network_config = var.network_config_file != null ? templatefile(
        var.network_config_file,
        {
            networking = var.network_config
        }
    ) : null
}
