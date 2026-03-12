terraform {
  required_version = ">= 1.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }
}

# -------------------------------------------------------------------
# Firestore Database
# -------------------------------------------------------------------
resource "google_firestore_database" "this" {
  project                     = local.project_id
  name                        = local.database_id
  location_id                 = local.location
  type                        = local.database_type
  delete_protection_state     = local.delete_protection_state
  point_in_time_recovery_enablement = local.point_in_time_recovery
  concurrency_mode            = local.concurrency_mode
}

# -------------------------------------------------------------------
# Composite Indexes
# -------------------------------------------------------------------
resource "google_firestore_index" "this" {
  for_each = { for idx in local.indexes : idx.key => idx }

  project    = local.project_id
  database   = google_firestore_database.this.name
  collection = each.value.collection
  query_scope = each.value.query_scope
  api_scope   = each.value.api_scope

  dynamic "fields" {
    for_each = each.value.fields
    content {
      field_path = fields.value.field_path
      order      = try(fields.value.order, null)
      array_config = try(fields.value.array_config, null)
    }
  }
}

# -------------------------------------------------------------------
# Seed Documents
# -------------------------------------------------------------------
resource "google_firestore_document" "this" {
  for_each = { for doc in local.documents : doc.key => doc }

  project     = local.project_id
  database    = google_firestore_database.this.name
  collection  = each.value.collection
  document_id = each.value.document
  fields      = each.value.fields
}

# -------------------------------------------------------------------
# Backup Schedules
# -------------------------------------------------------------------
resource "google_firestore_backup_schedule" "daily" {
  for_each = { for k, v in local.backup_schedules : k => v if v.recurrence == "daily" }

  project  = local.project_id
  database = google_firestore_database.this.name

  retention = each.value.retention

  daily_recurrence {}
}

resource "google_firestore_backup_schedule" "weekly" {
  for_each = { for k, v in local.backup_schedules : k => v if v.recurrence == "weekly" }

  project  = local.project_id
  database = google_firestore_database.this.name

  retention = each.value.retention

  weekly_recurrence {
    day = try(each.value.day, "SUNDAY")
  }
}
