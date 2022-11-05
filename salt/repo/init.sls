repo:
  file:
    - recurse
    - name: /etc/yum.repos.d
    - source: salt://repo/yum/
    - user: root
    - file_mode: '0755'



