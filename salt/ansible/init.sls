ansible:
  pkg:
    - installed
    - name: ansible
  file:
    - recurse
    - name: /etc/ansible
    - source: salt://ansible/files/
    - user: root
    - file_mode: '0755'