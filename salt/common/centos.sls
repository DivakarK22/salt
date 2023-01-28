{% if grains['os'] == 'CentOS' %}
centos:
  pkg:
    - installed
    - name: vsftpd
{% else %}
  pkg:
    - installed
    - name: lm_sensors
{% endif %}