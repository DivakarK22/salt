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
  k8.installed:
    - pkg: kubeadm
    - pkg: kubectl
    - pkg: kubelet
{% endif %}

{% if grains['id'] == 'sensu-core' %}
sensu-core:
  sensu-core.installed:
    - pkg: sensu-core
    - pkg: sensu-api
    - pkg: sensu-client
{% else %}
  sensu-core.installed:
    - pkg: sensu-client
{% endif %}

{% if grains['id'] == 'ftp' %}
ftp:
  ftp.installed:
    - pkg: unattended-upgrades
    - pkg: httpd
{% endif %}
