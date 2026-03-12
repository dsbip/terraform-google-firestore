# Firestore Terraform Module

A reusable Terraform module that provisions Google Cloud Firestore resources using a **YAML configuration file** as input.

## Features

- **Firestore Database** — native mode or Datastore mode
- **Composite Indexes** — per-collection with configurable query/API scope
- **Seed Documents** — optional initial documents per collection
- **Backup Schedules** — daily and/or weekly with configurable retention
- **Delete Protection & PITR** — optional safeguards

## Usage

```hcl
module "firestore" {
  source      = "./modules/firestore"
  config_file = "${path.module}/config.yaml"
}
```

## YAML Configuration Reference

```yaml
project_id: my-gcp-project          # required
location: us-central1                # required
database_type: FIRESTORE_NATIVE      # FIRESTORE_NATIVE | DATASTORE_MODE (default: FIRESTORE_NATIVE)
database_id: "(default)"             # default: "(default)"
delete_protection_state: DELETE_PROTECTION_DISABLED
point_in_time_recovery: POINT_IN_TIME_RECOVERY_DISABLED
concurrency_mode: OPTIMISTIC         # OPTIMISTIC | PESSIMISTIC

collections:
  users:
    indexes:
      by_email_created:
        query_scope: COLLECTION      # COLLECTION | COLLECTION_GROUP
        fields:
          - field_path: email
            order: ASCENDING
          - field_path: createdAt
            order: DESCENDING

    documents:
      admin_user:
        json_file: documents/admin_user.json  # path relative to config.yaml

backup_schedules:
  daily_backup:
    recurrence: daily
    retention: 604800s   # 7 days
  weekly_backup:
    recurrence: weekly
    retention: 2592000s  # 30 days
    day: SUNDAY
```

## Examples

| Scenario | Description |
|---|---|
| [minimal](examples/minimal/) | Database only with defaults |
| [full](examples/full/) | Database + indexes + documents + backups |
| [datastore_mode](examples/datastore_mode/) | Datastore-mode with collection group index |
| [multi_collection](examples/multi_collection/) | Multiple collections, array indexes, seed data |

## Validation

```bash
# Validate each example
for dir in examples/*/; do
  echo "=== Validating $dir ==="
  cd "$dir" && terraform init -backend=false && terraform validate && cd -
done
```
