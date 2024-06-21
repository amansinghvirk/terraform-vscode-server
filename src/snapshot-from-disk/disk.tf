resource "google_compute_snapshot" "snapshot" {
  name        = "vscode-vm-disk-snapshot01"
  source_disk = "projects/${local.project_id}/zones/us-central1-a/disks/vscode-vm-disk"
  zone        = local.zone
  labels = {
    my_label = "vscode-disk-volume"
  }
  storage_locations = [ local.region ]
}

output "disk-id" {
  value = google_compute_snapshot.snapshot.id
}

output "disk-name" {
  value = google_compute_snapshot.snapshot.name
}