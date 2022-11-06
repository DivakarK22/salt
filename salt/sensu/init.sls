sensu:
  file:
    - recurse
    - name: /etc/sensu/
    - source: salt://sensu/cfg/
  service:
    - running
    - name: sensu-agent
    - enable: True