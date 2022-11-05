salt-minion:
  file:
    - recurse
    - name: /etc/salt/
    - source: salt://salt-minion/cfg/
    - user: root
    - file_mode: '0755'