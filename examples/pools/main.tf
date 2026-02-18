module "create_pool" {
    source          = "../../modules/pool"
    pool_name       = "isos"
    pool_path       = "/data/isos"
}

module "create_pool_and_import_image" {
    source          = "../../modules/pool"
    pool_name       = "rocky"
    pool_path       = "/data/rocky"
    image_name      = "rocky-linux-10.1.qcow2"
    image_source    = "https://dl.rockylinux.org/pub/rocky/10/images/x86_64/Rocky-10-GenericCloud-Base.latest.x86_64.qcow2"
}

module "import_image_to_exsisting_pool" {
    source          = "../../modules/pool"
    pool_name       = "images"
    image_name      = "ubuntu-jammy-20260119.img"
    image_source    = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
}

module "import_image_from_local_file" {
    source          = "../../modules/pool"
    pool_name       = "images"
    image_name      = "ubuntu-noble-20260216.img"
    image_source    = "/home/beruanglaut/terraform-libvirt/example/noble-server-cloudimg-amd64.img"
}
