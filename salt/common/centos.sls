{% if grains['os'] == 'CentOS' %}
centos:
  pkg:
    - installed
    - name: vsftpd
{% else %}
  pkg:
    - installed
    - name: lm_sensors
{% if grains['id'] == 'k8' %}
k8:
  pkg:
    - installed
    - name: kubeadm
    - name: kubectl
    - name: kubelet
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
{% if grains['id'] == 'ftp' %}
ftp:
  pkg:
    - installed
    - name: httpd
{% endif %}
{% endif %}
{% endif %}
{% endif %}



