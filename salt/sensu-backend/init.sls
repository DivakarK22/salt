sensu-backend:
  service:
    - running
    - name: sensu-backend
    - reload: True
    - enable: True
  pkg:
    - installed
    - name: sensu-backend
