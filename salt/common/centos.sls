{% if grains['os'] == 'CentOS' %}
centos:
  pkg.installed:
    - pkg: BASIC
    - pkg: vsftpd
{% else %}
  pkg.installed:
    - pkg: unattended-upgrades
    - pkg: lm_sensors
{% if grains['id'] == 'k8' %}
k8:
  pkg.installed:
    - pkg: unattended-upgrades
    - pkg: kubeadm
    - pkg: kubectl
    - pkg: kubelet
{% if grains['id'] == 'sensu-core' %}
sensu-core:
  pkg.installed:
    - pkg: unattended-upgrades
    - pkg: sensu-core
    - pkg: sensu-api
    - pkg: sensu-client
{% else %}
  pkg.installed:
    - pkg: unattended-upgrades
    - pkg: sensu-client
{% if grains['id'] == 'ftp' %}
ftp:
  pkg.installed:
    - pkg: unattended-upgrades
    - pkg: httpd
{% endif %}
{% endif %}
{% endif %}
{% endif %}