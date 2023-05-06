nfs:
  pkg.installed:
    - pkg: nfs-utils
  file:
    - recurse
    - name: /etc/
    - source: salt://nfs/fstab
    - user: root
    - file_mode: '0755'
