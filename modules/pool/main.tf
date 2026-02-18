resource "libvirt_pool" "pool" {
    count   = var.pool_path != null ? 1 : 0
    name    = var.pool_name
    type    = "dir"
    target {
        path = var.pool_path
    }
}

resource "libvirt_volume" "upload_image" {
    count       = var.image_source != null ? 1 : 0
    name        = var.image_name
    source      = var.image_source
    pool        = var.pool_name
    depends_on  = [ libvirt_pool.pool ]
}
