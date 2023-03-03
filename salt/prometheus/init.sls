prometheus:
  file:
    - recurse
    - name: ///etc/prometheus/
    - source: salt://prometheus/cfg/
    - user: root
    - file_mode: '0744'