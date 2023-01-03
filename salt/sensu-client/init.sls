sensu-client:
  file:
    - managed
    - user: root
    - group: root
    - mode: '0644'
    - names:
       - /etc/sensu/:
         - source: salt://sensu-client/conf.d/
       - /etc/sensu/:
         - source: salt://sensu-client/checks/

  pkg:
    - installed
    - pkgs: 
       - sensu
       - rabbitmq-server
  service:
    - running
    - name: sensu-client
    - enable: True