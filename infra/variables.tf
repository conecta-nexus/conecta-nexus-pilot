variable "project_id" {
  type        = string
  description = "El ID del proyecto de Google Cloud Platform (GCP)."
}

variable "region" {
  type        = string
  description = "Región de GCP para el despliegue del piloto."
  default     = "us-central1"
}

variable "zone" {
  type        = string
  description = "Zona específica de GCP dentro de la región seleccionada."
  default     = "us-central1-a"
}

variable "instance_name" {
  type        = string
  description = "Nombre de la instancia de Google Compute Engine."
  default     = "conecta-nexus-auth-pilot"
}

variable "machine_type" {
  type        = string
  description = "Tipo de máquina virtual (e2-small es ideal y económica para el piloto evaluable)."
  default     = "e2-small"
}

variable "boot_disk_size_gb" {
  type        = number
  description = "Tamaño del disco de arranque en Gigabytes."
  default     = 20
}
