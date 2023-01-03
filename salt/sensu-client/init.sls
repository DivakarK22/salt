sensu-client:
  file:
    - recurse
    - name: /etc/sensu/conf.d
    - source: salt://sensu-core/conf.d
    - user: root
    - file_mode: '0755'
  pkg:
    - installed
    - pkgs: 
       - sensu
       - rabbitmq-server
  service:
    - running
    - name: sensu-client
    - enable: True
  file:
    - recurse
    - name: /etc/sensu/checks
    - source: salt://sensu-core/checks
    - user: root
    - file_mode: '0755'