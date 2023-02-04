{% if grains['id'] == 'openvpn' %}
sensu-client:
  pkg.installed:
    - pkg: sensu-client
  service.running:
    - name: sensu-client
    - enable: True
{% endif %}