selinux:
  file:
    - recurse
    - name: /etc/selinux/
    - source: salt://selinux/cfg/
    - user: root
    - file_mode: '0744'