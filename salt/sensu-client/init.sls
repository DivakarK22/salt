sensu-client:
  file:
    file.managed:
    - user: root
    - group: root
    - mode: '0644'
    - names:
      - /etc/sensu/conf.d:
        - source: salt://sensu-client/conf.d
      - /etc/sensu/checks:
        - source: salt://sensu-client/checks

  pkg:
    - installed
    - pkgs: 
       - sensu
       - rabbitmq-server
  service:
    - running
    - name: sensu-client
    - enable: True