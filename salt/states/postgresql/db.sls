# Password: python3 -c "import hashlib; print('md5' + hashlib.md5(b'12345678' + b'salt').hexdigest());"
Create salt database user:
  postgres_user.present:
    - name: salt
    - encrypted: True  # password is always encrypted
    - password: "{{ salt['pillar.get']('postgres_salt_md5password', 'md5c9d21e89dc04f9f2b446b4fbdafdf4b8') }}"
    - createdb: False
    - superuser: False
    - user: postgres   # run createuser as postgres

# Password: python3 -c "import hashlib; print('md5' + hashlib.md5(b'12345678' + b'saltro').hexdigest());"
Create salt RO database user:
  postgres_user.present:
    - name: saltro
    - encrypted: True  # password is always encrypted
    - password: "{{ salt['pillar.get']('postgres_saltro_md5password', 'md5600f52eab667226ca3185de50a34fae9') }}"
    - createdb: False
    - superuser: False
    - user: postgres   # run createuser as postgres

Create salt database:
  postgres_database.present:
    - name: salt
    - template: template0
    - encoding: UTF8
    - lc_ctype: en_US.UTF-8
    - lc_collate: en_US.UTF-8
    - owner: salt
    - user: postgres
    - require:
      - postgres_user: Create salt database user

Copy SQL script:
  file.managed:
    - name: /etc/postgresql/12/main/create_tables.sql
    - source: salt://postgresql/files/create_tables.sql

Create tables:
  cmd.run:
    - runas: postgres
    - name: psql -d salt -f /etc/postgresql/12/main/create_tables.sql
