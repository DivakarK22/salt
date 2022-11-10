sensu:
  service:
    - running
    - name: sensu-agent
    - reload: True
    - enable: True
  pkg:
    - installed
    - name: sensu-go-agent
