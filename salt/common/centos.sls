{% if grains['os'] == 'CentOS' %}
vsftpd:
  pkg.installed:
    - pkg: vsftpd
{% else %}
  pkg.installed:
    - pkg: lm_sensors
{% endif %}

{% if grains['id'] == 'k8' %}
kubeadm:
  pkg.installed:
    - pkg: kubeadm
kubelet:
  pkg.installed:
    - pkg: kubelet
kubectl:
  pkg.installed:
    - pkg: kubectl
{% endif %}

{% if grains['id'] == 'sensu-core' %}
sensu-core:
  pkg.installed:
    - pkg: sensu-core
sensu-client:
  pkg.installed:
    - pkg: sensu-client
sensu-api:
  pkg.installed:
    - pkg: sensu-api
{% else %}
sensu-client:
  pkg.installed:
    - pkg: sensu-client
{% endif %}

{% if grains['id'] == 'ftp' %}
httpd:
  pkg.installed:
    - pkg: httpd
{% endif %}
