Configure Salt Postgres cache:
  file.managed:
    - name: /etc/salt/master.d/postgres-cache.conf
    - source: salt://{{ slspath }}/files/postgres-cache.conf
    - template: jinja

Restart Salt master:
  cmd.run:
    - name: 'salt-call --local service.restart salt-master'
    - bg: true
    - onchanges:
      - file: Configure Salt Postgres cache
