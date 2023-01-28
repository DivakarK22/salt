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
{% if grains['id'] == 'k8' %}
k8:
  pkg:
    - installed
    - name: kubeadm
    - name: kubectl
    - name: kubelet
{% endif %}
{% if grains['id'] == 'sensu-core' %}
sensu-core:
  pkg:
    - installed
    - name: sensu-core
    - name: sensu-api
    - name: sensu-client
{% else %}
  pkg:
    - installed
    - name: sensu-client
{% endif %}
{% if grains['id'] == 'ftp' %}
ftp:
  pkg:
    - installed
    - name: httpd
{% endif %}