resource "google_compute_disk" "vm-disk" {
    name = "vscode-vm-disk"
    size = local.disk_size
    zone = local.zone
    type = local.disk_type
}

output "disk-id" {
  value = google_compute_disk.vm-disk.id
}

output "disk-name" {
  value = google_compute_disk.vm-disk.name
}