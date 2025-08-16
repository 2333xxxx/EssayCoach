# Auth & Permissions

This page documents default groups/permissions and how we bootstrap them for development, plus guidance on enforcing access rules in code.

## Default Groups

- `admin`: full user-management permissions + view student stats
- `lecturer`: can view users + view student stats, cannot add new users
- `student`: no model-level user permissions; must only access own data

## Custom Permission

- `core.view_student_stats` – allows viewing student statistics, assigned to `admin` and `lecturer`.

## Bootstrapping

- Migrations
  - `core/0002_default_groups.py` – create groups and map existing users by `user_role`
  - `core/0004_setup_permissions.py` – create `core.view_student_stats` and assign permissions to groups
  - `core/0003_add_fk_to_m2m.py` – add FKs to `auth_group`/`auth_permission` from our M2M tables
- Startup script
  - `scripts/dev-env/start-backend.sh` ensures:
    - Admin user exists (`admin` / `admin`)
    - Default groups exist and admin is in the `admin` group
    - Custom permission exists and group permissions are assigned

All steps are idempotent to allow seamless re-runs.

## Enforcing “Student Own Data”

- Implement in views/serializers by filtering on `request.user` and object ownership.
- Example (Django/DRF):
```python
def get_queryset(self):
    qs = super().get_queryset()
    user = self.request.user
    if user.groups.filter(name='student').exists() and not user.is_staff:
        qs = qs.filter(user_id=user.pk)
    return qs
```

For more granular, per-object permissions managed in the DB, consider integrating `django-guardian` (not required at present).

## References

- Model: `backend/core/models.py` (`User`)
- Admin: `backend/core/admin.py`
- Migrations: `backend/core/migrations/0002_*`, `0003_*`, `0004_*`
- DB init: `docker/db/init/00_init.sql`
- Startup: `scripts/dev-env/start-backend.sh`

