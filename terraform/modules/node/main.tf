
data "google_compute_image" "ubuntu" {
  family  = "ubuntu-2004-lts"
  project = "ubuntu-os-cloud"
}

resource "google_compute_instance" "vm" {
  name           = var.virtual_machine_name
  can_ip_forward = true
  machine_type   = "e2-standard-2"

  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu.self_link
      size  = 200
    }
  }

  metadata = var.metadata

  network_interface {
    network_ip = var.private_ip_address
    subnetwork = var.subnet_name
  }

  service_account {
    scopes = [
      "compute-rw", 
      "storage-ro", 
      "service-management", 
      "service-control", 
      "logging-write", 
      "monitoring"]
  }

  tags = var.tags
}

# resource "tls_self_signed_cert" "cert" {
#   count = var.create_cert ? 1 : 0

#   private_key_pem = file("${path.root}/../cert-auth/ca-key.pem")

#   subject {
#     common_name         = "system:node:${google_compute_instance.vm.name}"
#     country             = "CA"
#     locality            = "Montreal"
#     organization        = "system:nodes"
#     organizational_unit = "K8s The Hard Way"
#     province            = "Quebec"
#   }

#   validity_period_hours = 8760

#   allowed_uses = [
#     "cert_signing",
#     "client_auth",
#     "key_encipherment",
#     "server_auth"
#   ]
# }