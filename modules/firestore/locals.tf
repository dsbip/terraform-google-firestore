locals {
  config = yamldecode(file(var.config_file))

  project_id              = local.config.project_id
  location                = local.config.location
  database_type           = try(local.config.database_type, "FIRESTORE_NATIVE")
  database_id             = try(local.config.database_id, "(default)")
  delete_protection_state = try(local.config.delete_protection_state, "DELETE_PROTECTION_DISABLED")
  point_in_time_recovery  = try(local.config.point_in_time_recovery, "POINT_IN_TIME_RECOVERY_DISABLED")
  concurrency_mode        = try(local.config.concurrency_mode, "OPTIMISTIC")

  # Flatten indexes from collections
  indexes = flatten([
    for col_name, col in try(local.config.collections, {}) : [
      for idx_key, idx in try(col.indexes, {}) : {
        key             = "${col_name}-${idx_key}"
        collection      = col_name
        query_scope     = try(idx.query_scope, "COLLECTION")
        api_scope       = try(idx.api_scope, "ANY_API")
        fields          = idx.fields
      }
    ]
  ])

  # Resolve the base directory of the config file for relative JSON paths
  config_dir = dirname(var.config_file)

  # Flatten documents from collections — each document points to a JSON file
  documents = flatten([
    for col_name, col in try(local.config.collections, {}) : [
      for doc_name, doc in try(col.documents, {}) : {
        key        = "${col_name}-${doc_name}"
        collection = col_name
        document   = doc_name
        fields     = file("${local.config_dir}/${doc.json_file}")
      }
    ]
  ])

  # Backup schedules
  backup_schedules = try(local.config.backup_schedules, {})
}
