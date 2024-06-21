#########################
## GCP Linux VM - Main ##
#########################

resource "tls_private_key" "linuxkey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "linuxpemkey" {
  filename  = "linuxkey.pem"
  content   = tls_private_key.linuxkey.private_key_pem 

  depends_on = [ tls_private_key.linuxkey ]
}

data "template_file" "startup-script-new-disk" {
  template = "${file("start.sh")}"
}

# Create VM
resource "google_compute_instance" "vm_instance_public" {
  name         = "vscode-server-vm01"
  machine_type = var.cpu_instance_type
  zone         = local.zone
  tags         = ["ssh", "http"]

  metadata = {
    ssh-keys = "gce:${tls_private_key.linuxkey.public_key_openssh}" 
    startup-script  = data.template_file.startup-script-new-disk.rendered

  }


  boot_disk {
    initialize_params {
      #image = var.gpu_image
      image = var.cpu_image
      size  = 50 // 50 GB Storage
    }
  }

  attached_disk {
    source =  "projects/${local.project_id}/zones/us-central1-a/disks/vscode-vm-disk"
  }

  network_interface {
    network       = google_compute_network.vpc.name
    subnetwork    = google_compute_subnetwork.vpc-subnet.name
    access_config { }
  }

  # guest_accelerator {
  #   type  = "nvidia-l4"
  #   count = 1
  # }

  scheduling {
    on_host_maintenance = "TERMINATE"
  }

} 