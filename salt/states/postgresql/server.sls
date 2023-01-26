Ensure postgresql is installed:
  pkg.installed:
    - pkgs:
      - postgresql
      - postgresql-server-dev-12

Postgresql hba config:
  file.managed:
    - name: /etc/postgresql/12/main/pg_hba.conf
    - source: salt://postgresql/files/pg_hba.conf
    - template: jinja
    - user: postgres
    - group: postgres
    - mode: 640
    - watch_in:
      - service: Postgresql service
    - require_in:
      - service: Postgresql service

Postgresql config:
  file.managed:
    - name: /etc/postgresql/12/main/postgresql.conf
    - source: salt://postgresql/files/postgresql.conf
    - template: jinja
    - user: postgres
    - group: postgres
    - mode: 644
    - watch_in:
      - service: Postgresql service
    - require_in:
      - service: Postgresql service

Postgresql service:
  service.running:
    - name: postgresql
    - enable: True
    # WARN: some configuration parameters require restart
    - reload: True
    - require:
      - pkg: Ensure postgresql is installed

Psycopg2 package:
  pkg.installed:
    - name: python3-psycopg2

Psycopg2 pip package:
  pip.installed:
    - name: psycopg2
