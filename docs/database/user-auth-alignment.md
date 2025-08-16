# Custom User Alignment (Aug 2025)

This document explains the alignment work between our existing database `user` table and Django’s authentication expectations, plus the rationale and references for the related migrations.

## Summary of Changes

- Aligned DB columns with Django’s `AbstractBaseUser` + `PermissionsMixin` requirements while keeping existing business fields.
  - Added columns: `is_superuser`, `is_staff`, `is_active`, `last_login`, `date_joined`.
  - Kept existing fields: `user_id`, `user_email`, `user_fname`, `user_lname`, `user_role`, `user_status`, `user_credential` (maps to Django `password`).
- Introduced Django M2M tables for groups and permissions (for custom user):
  - `core_user_groups(user_id, group_id)`
  - `core_user_user_permissions(user_id, permission_id)`
- Widened `user_email` to `varchar(254)` to match Django `EmailField` default.
- Bootstrapped default groups and permissions (admin, lecturer, student; custom permission `core.view_student_stats`).

## Reasons and Context

- Resolve migration/runtime errors where Django admin/auth selects `last_login`/`is_superuser` from the user table.
- Enable Django-native groups/permissions for access control instead of hard-coding `user_role` checks.
- Maintain compatibility with existing data model, relationships, and constraints (e.g., `user_role` CHECK), while enabling a smooth transition towards permissions-based authorization.

## Affected Files (Sources)

- Backend model/state
  - `backend/core/models.py` (custom `User`, helpers and admin display)
  - `backend/core/migrations/0001_initial.py` (state-only model for managed=False tables)
- Migrations added
  - `backend/core/migrations/0002_default_groups.py` – Create default groups and map `user_role` → groups
  - `backend/core/migrations/0003_add_fk_to_m2m.py` – Add FKs from M2M tables to `auth_group`/`auth_permission`
  - `backend/core/migrations/0004_setup_permissions.py` – Create `core.view_student_stats` and assign group permissions
  - `backend/core/migrations/0005_widen_user_email_len.py` – Widen `user_email` to 254 (safe/conditional)
- Startup automation
  - `scripts/dev-env/start-backend.sh` – Ensures admin user exists; ensures default groups/permissions and admin membership (idempotent)
- DB initialization (cold start)
  - `docker/db/init/00_init.sql` – Adds Django-compatible columns and M2M tables; widens `user_email` to 254

## New/Updated Entities

### public."user"

- Columns (subset):
  - `user_id integer PRIMARY KEY`
  - `user_email varchar(254) UNIQUE` (Django `EmailField`)
  - `user_credential varchar(255)` (Django `password`)
  - `is_superuser boolean NOT NULL DEFAULT false`
  - `is_staff boolean NOT NULL DEFAULT false`
  - `is_active boolean NOT NULL DEFAULT true`
  - `last_login timestamp NULL`
  - `date_joined timestamp NOT NULL DEFAULT now()`
  - `user_role varchar(10)` with CHECK (`student|lecturer|admin`) – retained for compatibility
  - `user_status varchar(15)` with CHECK – retained

### public.core_user_groups

- `id bigserial PRIMARY KEY`
- `user_id integer NOT NULL` → FK to `public."user"(user_id)` (CASCADE)
- `group_id integer NOT NULL` → FK to `auth_group(id)` (via migration)
- `UNIQUE(user_id, group_id)`

### public.core_user_user_permissions

- `id bigserial PRIMARY KEY`
- `user_id integer NOT NULL` → FK to `public."user"(user_id)` (CASCADE)
- `permission_id integer NOT NULL` → FK to `auth_permission(id)` (via migration)
- `UNIQUE(user_id, permission_id)`

## Default Groups & Permissions

- Groups created: `admin`, `lecturer`, `student`.
- Custom permission: `core.view_student_stats` (content type `core.user`).
- Assignments:
  - `admin`: add/change/delete/view user + view_student_stats
  - `lecturer`: view user + view_student_stats (can view student stats, cannot add users)
  - `student`: no model-level user perms (enforce “own data” in view layer)

## Migration Order and Safety

1. 0001 – Register `core.User` in migration state (managed=False).
2. 0002 – Create default groups; map `user_role` → `core_user_groups`.
3. 0003 – Add foreign keys to `auth_group`/`auth_permission`.
4. 0004 – Create custom permission and assign to groups.
5. 0005 – Widen `user_email` to 254 (idempotent check).

These migrations are safe to re-run and are idempotent where practical. Cold-start SQL (00_init.sql) is also aligned so fresh environments do not rely solely on migrations for critical columns.

## Developer Notes

- Creation of users via admin is now supported (if `user_id` is generated externally, keep creating users through provisioning scripts).
.- Prefer authorization through Django groups/permissions. `user_role` should be considered a legacy/denormalized label during transition.
- “Student can only access own data” is enforced in views/serializers by filtering on `request.user` (object-level). Consider `django-guardian` if you need row-level permissions managed via DB.

