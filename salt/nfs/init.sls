nfs:
  file:
    - recurse
    - name: /etc/
    - source: salt://nfs/fstab
    - user: root
    - file_mode: '0755'