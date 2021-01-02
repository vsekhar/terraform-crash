provider "google" {
    alias = "g"
    project = var.project_id
}

provider "google-beta" {
    alias = "gb"
    project = var.project_id
}

data "google_container_registry_image" "hello-app" {
  project = "google-samples"
  name = "hello-app:2.0"
}

module "hello-template" {
    source = "../../container_vm"
    providers = {
        google = google.g
        google-beta = google-beta.gb
    }
    name = "hello-app"
    container_image = data.google_container_registry_image.hello-app
    host_to_container_ports = {
        "80" = "8080"
    }
    preemptible = true
    machine_type = "e2-small"
}

module "hello_service" {
    source = "../"
    providers = {
        google = google.g
        google-beta = google-beta.gb
    }
    name = "test"
    region = "us-central1"
    min_replicas = 1

    versions = [
        {
            name = "hello-app"
            instance_template = module.hello-template.self_link
            target_size = {
                fixed = null
                percent = null
            }
        }
    ]
}
