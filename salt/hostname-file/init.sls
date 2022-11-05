hostname-file:
  file:
    - recurse
    - name: /etc/
    - source: salt://hostname-file/hosts/