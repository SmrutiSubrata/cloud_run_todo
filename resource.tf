provider "google" {
  project     = "commanding-iris-426713-m5"
  region      = "us-central1"
  credentials = file("/Users/apple/Desktop/commanding-iris-426713-m5-c98ec9f1df54.json")
}

resource "google_cloud_run_service" "cloudrun" {
  name     = "terraform-cloud-run"
  location = "us-central1"

  template {
    spec {
      containers {
        image = "gcr.io/commanding-iris-426713-m5/smruti:e0c20c75fbd30c4a6f49fdf3fd81e9596ba6d0ca"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  # Disable automatic revision name generation
  autogenerate_revision_name = false
}

resource "google_cloud_run_service_iam_policy" "cloudrun_policy" {
  service = google_cloud_run_service.cloudrun.name

  policy_data = <<EOF
{
  "bindings": [
    {
      "role": "roles/run.invoker",
      "members": [
        "allUsers"
      ]
    }
  ]
}
EOF
}
