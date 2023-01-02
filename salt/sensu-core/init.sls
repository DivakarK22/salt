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
       - sensu-server
       - sensu-api
       - sensu-uchiwa
  service:
    - running
    - name: sensu-server
    - enable: True