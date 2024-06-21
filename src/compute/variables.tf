variable "gcp_credentials" {
    type=string
    description = "Path to the credentials file"
    default=".gcp-credentials.json"
}

variable "allow_ips" {
    type=list(string)
    description = "list of allowed ips"
    default=["59.178.134.175/32"]
}

variable "cpu_instance_type" {
    type=string
    description = "Type of the instance"
    default="n2-standard-4"
}

variable "gpu_instance_type" {
    type=string
    description = "Type of the instance"
    default="g2-standard-4"
}

variable "cpu_image" {
    type        = string
    description = "SKU for Ubuntu 20.04 LTS"
    default     = "ubuntu-os-cloud/ubuntu-2004-lts"
}

variable "gpu_image" {
    type=string
    description = "Image to be used for VM creation"
    default="deeplearning-platform-release/common-cu113-debian-11-py310"
}
