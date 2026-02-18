terraform {
    required_version = ">= 1.6"
    required_providers {
        libvirt = {
            source = "dmacvicar/libvirt"
            version = "0.8.3"
        }
    }
}

# Use local provider
provider "libvirt" {
    uri = "qemu:///system"
}

# Use external provider
#provider "libvirt" {
#    uri = "qemu+ssh://root@YOUR_ADDRESS:YOUR_PORT/system?keyfile=/path/to/key&sshauth=privkey&no_verify=1""
#}
