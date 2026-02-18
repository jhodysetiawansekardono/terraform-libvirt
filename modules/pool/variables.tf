variable "pool_name" {
    description = "The name of the libvirt storage pool"
    type        = string
    default     = null
}

variable "pool_path" {
    description = "The filesystem path for the libvirt storage pool"
    type        = string
    default     = null
}

variable "image_name" {
    description = "The name of the base OS image volume to create in the storage pool"
    type        = string
    default     = null
}

variable "image_source" {
    description = "The local filesystem path or remote URL of the base OS image to upload into the storage pool"
    type        = string
    default     = null
}
