sensu:
  service:
    - running
    - name: sensu-go-agent
    - reload: True
    - enable: True
  pkg:
    - installed
    - name: sensu-go-agent
