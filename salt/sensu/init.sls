sensu:
  file:
    - recurse
    - name: /etc/sensu/
    - source: salt://sensu/cfg/
  file:
    - recurse
    - name: /etc/sensu/
    - source: salt://sensu/checks/
  service:
    - running
    - name: sensu-agent
    - enable: True