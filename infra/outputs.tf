output "public_ip" {
  description = "Dirección IP pública estática asignada a la instancia de GCP."
  value       = google_compute_address.static_ip.address
}

output "frontend_url" {
  description = "URL de acceso a la interfaz web Nuxt 4."
  value       = "http://${google_compute_address.static_ip.address}:3000"
}

output "backend_api_url" {
  description = "URL base de los endpoints REST del microservicio Django."
  value       = "http://${google_compute_address.static_ip.address}:8000/api/v1/auth/"
}

output "ssh_command" {
  description = "Comando de gcloud para conectarse de inmediato por SSH a la VM."
  value       = "gcloud compute ssh ${google_compute_instance.auth_vm.name} --zone=${var.zone} --project=${var.project_id}"
}

output "useful_commands" {
  description = "Comandos útiles para verificación de estado y visualización de logs en vivo."
  value = {
    "ver_logs_arranque"    = "sudo journalctl -u google-startup-scripts.service -f",
    "ver_logs_backend"     = "sudo journalctl -u conecta-backend -f",
    "ver_logs_frontend"    = "sudo journalctl -u conecta-frontend -f",
    "probar_healthcheck"   = "curl -s http://${google_compute_address.static_ip.address}:8000/api/v1/auth/health/ | jq",
    "probar_registro_curl" = "curl -X POST http://${google_compute_address.static_ip.address}:8000/api/v1/auth/register/ -H 'Content-Type: application/json' -d '{\"email\":\"test@ufps.edu.co\",\"password\":\"Pass123*\",\"role\":\"ESTUDIANTE\",\"habeas_data_consent\":true}'"
  }
}
