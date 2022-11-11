prometheus:
  file:
    - recurse
    - name: ///root/prometheus-2.18.1.linux-amd64/
    - source: salt://prometheus/cfg/
    - user: root
    - file_mode: '0744'