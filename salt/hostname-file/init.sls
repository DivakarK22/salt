{% if grains['os'] == 'CentOS' %}
hostname-file:
  file:
    - recurse
    - name: /etc/
    - source: salt://hostname-file/hosts/
{% else %}
  file:
    - recurse
    - name: C:\Windows\System32\drivers\etc
    - source: salt://hostname-file/win-hosts/