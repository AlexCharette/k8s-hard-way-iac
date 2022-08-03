
resource "google_compute_network" "vnet" {
  name = "learn-k8s-vnet"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name = "learn-k8s-subnet"
  network = google_compute_network.vnet.id
  ip_cidr_range = "10.240.0.0/24"
}

resource "google_compute_firewall" "fw-allow-int" {
  name = "learn-k8s-allow-int"
  network = google_compute_network.vnet.name
  direction = "INGRESS"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  source_ranges = ["10.240.0.0/24", "10.200.0.0/16"]
}

resource "google_compute_firewall" "fw-allow-ext" {
  name      = "learn-k8s-allow-ext"
  network   = google_compute_network.vnet.name
  direction = "INGRESS"

  allow {
    protocol = "icmp"
  } 

  allow {
    protocol = "tcp"
    ports = ["22", "6443"]
  }

  source_ranges = ["0.0.0.0/10"]
}

resource "google_compute_address" "ip" {
  name = "learn-k8s-ip"
  address_type = "EXTERNAL"
}

module "control_plane" {
  source = "./modules/node"
  count  = 3

  metadata = {}
  create_cert = false
  private_ip_address     = "10.240.0.1${count.index}"
  virtual_machine_name   = "control-plane-${count.index}"
  subnet_name   = google_compute_subnetwork.subnet.name
  tags = ["k8s", "control-plane"]
}

module "worker" {
  source = "./modules/node"
  count  = 3

  metadata = {
    pod-cidr = "10.200.${count.index}.0/24"
  }
  create_cert = true
  private_ip_address     = "10.240.0.2${count.index}"
  virtual_machine_name   = "worker-${count.index}"
  subnet_name   = google_compute_subnetwork.subnet.name
  tags = ["k8s", "worker"]
}