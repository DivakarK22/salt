auditbeat:
  pkg:
    - installed
    - name: auditbeat
  service.running:
    - name: auditbeat
    - enable: True
  file:
    - recurse
    - name: /etc/auditbeat/
    - source: salt://auditbeat/auditbeat/
    - user: root
    - file_mode: '0744'
