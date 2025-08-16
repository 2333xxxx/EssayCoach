from django.db import migrations, models


class Migration(migrations.Migration):
    initial = True

    # Keep dependencies empty so this migration can run early
    dependencies = []

    operations = [
        # Register the existing custom user table in migration state so
        # other apps (e.g. admin) can resolve AUTH_USER_MODEL during
        # their initial migrations. The table already exists; we mark it
        # managed = False to avoid Django trying to create/alter it.
        migrations.CreateModel(
            name='User',
            fields=[
                ('user_id', models.IntegerField(primary_key=True, serialize=False)),
                ('user_email', models.EmailField(max_length=254, unique=True)),
                ('user_fname', models.CharField(blank=True, max_length=20, null=True)),
                ('user_lname', models.CharField(blank=True, max_length=20, null=True)),
                ('user_role', models.CharField(blank=True, max_length=10, null=True)),
                ('user_status', models.CharField(blank=True, max_length=15, null=True)),
                ('password', models.CharField(max_length=255)),
                ('is_active', models.BooleanField(default=True)),
                ('is_staff', models.BooleanField(default=False)),
                ('date_joined', models.DateTimeField(auto_now_add=True)),
            ],
            options={
                'db_table': 'user',
                'managed': False,
            },
        ),
    ]
