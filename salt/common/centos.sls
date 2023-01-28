{% if grains['os'] == 'CentOS' %}
vsftpd:
  pkg.installed:
    - pkg: vsftpd
{% else %}
  pkg.installed:
    - pkg: lm_sensors
{% endif %}

{% if grains['id'] == 'k8' %}
k8:
  pkg.installed:
    - pkg: kubeadm
    - pkg: kubectl
    - pkg: kubelet
{% endif %}

{% if grains['id'] == 'sensu-core' %}
sensu-core:
  pkg.installed:
    - pkg: sensu-core
    - pkg: sensu-api
    - pkg: sensu-client
{% else %}
  pkg.installed:
    - pkg: sensu-client
{% endif %}

{% if grains['id'] == 'ftp' %}
ftp:
  pkg.installed:
    - pkg: unattended-upgrades
    - pkg: httpd
{% endif %}
