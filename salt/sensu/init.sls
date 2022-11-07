sensu:
  file:
    - recurse
    - name: /etc/sensu/
    - source: salt://sensu/cfg/
    - file_mode: '0777'
  service:
    - running
    - name: sensu-agent
    - enable: True