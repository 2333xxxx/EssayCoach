from django.db import migrations


SQL = r'''
DO $$
DECLARE
    v_len integer;
BEGIN
    SELECT CASE WHEN a.atttypmod > 4 THEN a.atttypmod - 4 ELSE NULL END
      INTO v_len
    FROM pg_attribute a
    JOIN pg_class c ON a.attrelid = c.oid
    JOIN pg_namespace n ON c.relnamespace = n.oid
    WHERE n.nspname = 'public' AND c.relname = 'user' AND a.attname = 'user_email';

    IF v_len IS DISTINCT FROM 254 THEN
        ALTER TABLE public."user"
        ALTER COLUMN user_email TYPE varchar(254);
    END IF;
END$$;
'''


class Migration(migrations.Migration):
    dependencies = [
        ('core', '0004_setup_permissions'),
    ]

    operations = [
        migrations.RunSQL(SQL),
    ]

