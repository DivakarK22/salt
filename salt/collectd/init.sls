collectd:
  pkg:
    - installed
    - name: collectd
  service.running:
    - name: collectd
    - enable: True
  file:
    - recurse
    - name: /etc/
    - source: salt://collectd/cfg/
    - user: root
    - file_mode: '0744'