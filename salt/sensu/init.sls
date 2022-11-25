sensu:
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
    - name: /etc/sensu/agent.yml
    - source: salt://sensu/cfg/
    - user: root
    - file_mode: '0755'
