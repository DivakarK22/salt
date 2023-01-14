sudoers:
  file:
    - recurse
    - name: /etc/
    - source: salt://sudoers/file/