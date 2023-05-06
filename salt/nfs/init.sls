nfs-utils:
  pkg.installed:
    - pkg: nfs-utils
  cmd.run:
    - name: Create nfs and rvm
    - cwd: /
    - name: mkdir /nfs
    - name: mkdir /usr/local/rvm
  file:
    - recurse
    - name: /etc/
    - source: salt://nfs/fstab
    - user: root
    - file_mode: '0755'
