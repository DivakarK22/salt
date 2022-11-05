salt-master:
  file:
    - recurse
    - name: /etc/salt/
    - source: salt://salt-master/cfg/
    - user: root
    - file_mode: '0755'