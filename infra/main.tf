terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# Reserva de dirección IP externa estática para acceso confiable
resource "google_compute_address" "static_ip" {
  name        = "${var.instance_name}-ip"
  description = "IP publica estatica para el piloto auth-service Conecta Nexus (UFPS)"
}

# Regla de Firewall para SSH, Backend Django (:8000) y Frontend Nuxt (:3000)
resource "google_compute_firewall" "conecta_nexus_firewall" {
  name        = "${var.instance_name}-fw-rules"
  network     = "default"
  description = "Permite trafico evaluable hacia SSH (22), API Django (8000) y Nuxt 4 (3000)"

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "3000", "8000"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["conecta-nexus-pilot"]
}

# Instancia Virtual de Google Compute Engine
resource "google_compute_instance" "auth_vm" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["conecta-nexus-pilot"]

  description = "Servidor GCE de ejecucion unificada para el piloto Conecta Nexus"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = var.boot_disk_size_gb
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.static_ip.address
    }
  }

  # Script de arranque desatendido que aprovisiona Python, pnpm, systemd
  metadata_startup_script = file("${path.module}/startup.sh")

  service_account {
    scopes = ["cloud-platform"]
  }

  labels = {
    entorno     = "piloto-academico"
    universidad = "ufps"
    servicio    = "auth-service"
  }
}
