metricbeat:
  pkg:
    - installed
    - name: metricbeat
    - running
    - enable: True
  file:
    - recurse
    - name: ///etc/metricbeat/
    - source: salt://metricbeat/cfg/metricbeat.yml
    - user: root
    - file_mode: '0744'
metricbeat-elasticsearch-xpack-copy:
  file:
    - recurse
    - name: ///etc/metricbeat/modules.d/
    - source: salt://metricbeat/cfg/elasticsearch-xpack.yml
    - user: root
    - file_mode: '0744'
metricbeat-elasticsearch-copy:
  file:
    - recurse
    - name: ///etc/metricbeat/modules.d/
    - source: salt://metricbeat/cfg/elasticsearch.yml
    - user: root
    - file_mode: '0744'
