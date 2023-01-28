{% if grains['os'] == 'CentOS' %}
vsftpd:
  pkg.installed:
    - pkg: vsftpd
  service.running:
    - name: vsftpd
    - enable: True
{% else %}
  pkg.installed:
    - pkg: lm_sensors
  service.running:
    - name: lm_sensors
    - enable: True
{% endif %}

{% if grains['id'] == 'k8' %}
kubeadm:
  pkg.installed:
    - pkg: kubeadm
  service.running:
    - name: kubeadm
    - enable: True
kubelet:
  pkg.installed:
    - pkg: kubelet
  service.running:
    - name: kubelet
    - enable: True
kubectl:
  pkg.installed:
    - pkg: kubectl
  service.running:
    - name: kubectl
    - enable: True
{% endif %}

{% if grains['id'] == 'sensu-core' %}
sensu-core:
  pkg.installed:
    - pkg: sensu-server
  service.running:
    - name: sensu-api
    - enable: True
sensu-client:
  pkg.installed:
    - pkg: sensu-server
  service.running:
    - name: sensu-client
    - enable: True
sensu-api:
  pkg.installed:
    - pkg: sensu-server
  service.running:
    - name: sensu-server
    - enable: True
{% else %}
sensu-client:
  pkg.installed:
    - pkg: sensu-server
  service.running:
    - name: sensu-client
    - enable: True
{% endif %}

{% if grains['id'] == 'ftp' %}
httpd:
  pkg.installed:
    - pkg: httpd
  service.running:
    - name: httpd
    - enable: True
{% endif %}
