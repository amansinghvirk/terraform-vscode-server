resource "google_compute_network" "vpc" {
    name = "ollama-network"
    auto_create_subnetworks = false
}   

resource "google_compute_subnetwork" "vpc-subnet" {
    name = "ollama-sub-sg"
    network = google_compute_network.vpc.id
    ip_cidr_range = "10.1.0.0/24"
    region = local.region
    private_ip_google_access = true

    depends_on = [ google_compute_network.vpc ]
}

resource "google_compute_firewall" "allow-vpc-traffic" {
    name = "allow-vpc-traffic-ollama"
    network = google_compute_network.vpc.id

    allow {
        protocol = "tcp"
        ports    = ["80"]
    }


    allow {
        protocol = "tcp"
        ports    = ["22"]
    }

    allow {
        protocol = "tcp"
        ports    = ["10000"]
    }

    allow {
        protocol = "tcp"
        ports    = ["8050"]
    }

    allow {
        protocol = "tcp"
        ports    = ["8051"]
    }

    allow {
        protocol = "tcp"
        ports    = ["8052"]
    }

    source_ranges = var.allow_ips
    depends_on = [ google_compute_network.vpc ]

}