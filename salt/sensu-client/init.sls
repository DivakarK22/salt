sensu-client:
  file:
    - recurse
    - name: /etc/sensu/conf.d
    - source: salt://sensu-client/conf.d
    - user: root
    - file_mode: '0755'
  file:
    - recurse
    - name: /etc/sensu/checks
    - source: salt://sensu-client/checks
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