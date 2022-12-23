sensu-agent:
  service:
    - running
    - name: sensu-agent
    - reload: True
    - enable: True
  pkg:
    - installed
    - name: sensu-go-agent
  file:
    - recurse
    - name: /etc/sensu/
    - source: salt://sensu-agent/
    - user: root
    - file_mode: '0755'
