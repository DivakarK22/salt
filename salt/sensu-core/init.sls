sensu-core:
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
  service:
    - running
    - name: 
       - sensu-server
       - sensu-api
       - sensu-client
    - enable: True