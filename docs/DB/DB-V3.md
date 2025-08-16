# Database V3 Details

This page supersedes Database V2 Details and documents the auth- and ORM-alignment work completed in Aug 2025.

## What’s New in V3 (Aug 2025)

- User table alignment with Django auth:
  - Added columns: `is_superuser` (bool), `is_staff` (bool), `is_active` (bool), `last_login` (timestamp), `date_joined` (timestamp)
  - Kept business fields: `user_email`, `user_fname`, `user_lname`, `user_status`, `user_credential` (password)
  - Widened `user_email` to `varchar(254)` to match Django `EmailField`
- Introduced Django-native authorization join tables for the custom user:
  - `core_user_groups(id, user_id, group_id, UNIQUE(user_id, group_id))`
  - `core_user_user_permissions(id, user_id, permission_id, UNIQUE(user_id, permission_id))`
- Default groups and custom permission bootstrapped:
  - Groups: `admin`, `lecturer`, `student`
  - Permission: `core.view_student_stats` (assigned to admin + lecturer)

These changes eliminate migration/runtime errors in admin/auth, enable standard Django group/permission flows, and keep existing business fields/constraints.

## Updated Entities

### public."user"

Additional columns introduced in V3:

```sql
ALTER TABLE public."user"
  ADD COLUMN IF NOT EXISTS is_superuser boolean NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS is_staff boolean NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS is_active boolean NOT NULL DEFAULT true,
  ADD COLUMN IF NOT EXISTS last_login timestamp NULL,
  ADD COLUMN IF NOT EXISTS date_joined timestamp NOT NULL DEFAULT now();

ALTER TABLE public."user"
  ALTER COLUMN user_email TYPE varchar(254);
```

### public.core_user_groups

```sql
CREATE TABLE public.core_user_groups (
  id bigserial PRIMARY KEY,
  user_id integer NOT NULL REFERENCES public."user"(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
  group_id integer NOT NULL,
  CONSTRAINT core_user_groups_user_group_uq UNIQUE (user_id, group_id)
);
-- FK to auth_group(id) is added by migration for proper ordering
```

### public.core_user_user_permissions

```sql
CREATE TABLE public.core_user_user_permissions (
  id bigserial PRIMARY KEY,
  user_id integer NOT NULL REFERENCES public."user"(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
  permission_id integer NOT NULL,
  CONSTRAINT core_user_user_permissions_uq UNIQUE (user_id, permission_id)
);
-- FK to auth_permission(id) is added by migration for proper ordering
```

## Default Groups & Permissions

- Groups created: `admin`, `lecturer`, `student`
- Permission: `core.view_student_stats`
- Assignments:
  - admin: add/change/delete/view user + view_student_stats
  - lecturer: view user + view_student_stats
  - student: no model-level user perms (own-data enforcement happens in views)

## Diagram

The V2 ERD remains applicable with the following additions:

- New tables: `core_user_groups`, `core_user_user_permissions`
- Additional columns on `public."user"`

We will refresh the SVG in a future update. For now, refer to `DB-V2.svg` alongside the changes above.

## V2 Data Dictionary (Reference)

For the full, table-by-table dictionary inherited from V2, see: [Database V2 Details](DB-V2.md)

