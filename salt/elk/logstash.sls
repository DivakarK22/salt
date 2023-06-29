logstash:
  pkg:
    - installed
    - name: logstash
  service.running:
    - name: logstash
    - enable: True
  file:
    - recurse
    - name: /etc/logstash/
    - source: salt://elk/logstash/
    - user: root
    - file_mode: '0744'