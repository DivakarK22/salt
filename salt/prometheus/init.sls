prometheus:
  file:
    - recurse
    - name: //root/scripts/pushgateway-0.8.0.linux-amd64/prometheus-2.9.2.linux-amd64
    - source: salt://prometheus/cfg/
    - user: root
    - file_mode: '0744'