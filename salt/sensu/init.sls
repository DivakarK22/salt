sensu:
  file.managed:
    - name: /etc/systemd/system/sensu-agent.service
    - source: salt://sensu/cfg/sensu-agent.service
    - template: jinja
  module.run:
    - name: service.systemctl_reload
  file:
    - recurse
    - name: /etc/sensu/
    - source: salt://sensu/cfg/
    - file_mode: '0777'
  service:
    - running
    - name: sensu-agent
    - reload: True
    - enable: True
    - require:
      - pkgs:
        - sensu-go-agent
        - sensu-go-client
