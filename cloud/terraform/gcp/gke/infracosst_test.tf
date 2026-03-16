provider "google" {
  region = "us-central1"
  project = "test"
}

resource "google_compute_instance" "infracost_test_instance" {
  zone = "us-central1-a"
  name = "infracost-test-instance"

  machine_type = "n1-standard-16" # <<<<<<<<<< Try changing this to n1-standard-32 to compare the costs
  network_interface {
    network = "default"
    access_config {}
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  scheduling {
    preemptible = true
  }

  guest_accelerator {
    type  = "nvidia-tesla-t4" # <<<<<<<<<< Try changing this to nvidia-tesla-p4 to compare the costs
    count = 4
  }

  labels = {
    name        = "infracost-test-instance"
    environment = "production"
    service     = "web-app"
  }
}

resource "google_cloudfunctions_function" "infracost_test_function" {
  runtime             = "nodejs20"
  name                = "infracost-test-function"
  available_memory_mb = 512

  labels = {
    name        = "infracost-test-function"
    environment = "prod"
  }
}
