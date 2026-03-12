output "database_name" {
  description = "The resource name of the Firestore database"
  value       = google_firestore_database.this.name
}

output "database_id" {
  description = "The database ID"
  value       = google_firestore_database.this.id
}

output "location" {
  description = "The location of the database"
  value       = google_firestore_database.this.location_id
}

output "type" {
  description = "The database type (FIRESTORE_NATIVE or DATASTORE_MODE)"
  value       = google_firestore_database.this.type
}

output "index_ids" {
  description = "Map of created index IDs"
  value       = { for k, v in google_firestore_index.this : k => v.id }
}

output "document_ids" {
  description = "Map of created document IDs"
  value       = { for k, v in google_firestore_document.this : k => v.id }
}
