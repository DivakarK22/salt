metricbeat:
  pkg:
    - installed
    - name: metricbeat
  service.running:
    - name: metricbeat
    - enable: True
  file:
    - recurse
    - name: /etc/metricbeat/
    - source: salt://metricbeat/metricbeats/
    - user: root
    - file_mode: '0744'
metricbeat-elasticsearch-xpack-copy:
  file:
    - recurse
    - name: /etc/metricbeat/modules.d/
    - source: salt://metricbeat/es-metricbeats/
    - user: root
    - file_mode: '0744'
metricbeat-elasticsearch-copy:
  file:
    - recurse
    - name: /etc/metricbeat/modules.d/
    - source: salt://metricbeat/es-metricbeats/
    - user: root
    - file_mode: '0744'
