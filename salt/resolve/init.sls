resolve:
  file:
    - recurse
    - name: /etc/
    - source: salt://resolve/resolve-file/
    - user: root
    - file_mode: '0755'