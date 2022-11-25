prometheus:
  file:
    - recurse
    - name: ///root/prometheus/
    - source: salt://prometheus/cfg/
    - user: root
    - file_mode: '0744'