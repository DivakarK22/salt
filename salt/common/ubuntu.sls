sensu-client:
  pkg.installed:
    - pkg: sensu-client
  service.running:
    - name: sensu-client
    - enable: True