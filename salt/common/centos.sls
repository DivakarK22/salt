{% if grains['os'] == 'CentOS' %}
lm_sensors:
  pkg.installed:
    - pkg: lm_sensors
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
  service.running:
    - name: kubelet
    - enable: True
kubectl:
  pkg.installed:
    - pkg: kubectl
{% endif %}

{% if grains['id'] == 'sensu' %}
sensu:
  pkg.installed:
    - pkg: sensu
  service.running:
    - name: sensu-api
    - enable: True
sensu-client:
  service.running:
    - name: sensu-client
    - enable: True
sensu-api:
  service.running:
    - name: sensu-server
    - enable: True
  file:
    - recurse
    - name: /etc/sensu/conf.d-master
    - source: salt://sensu/conf.d
    - user: root
    - file_mode: '0755'
{% else %}
sensu-client:
  service.running:
    - name: sensu-client
    - enable: True
  file:
    - recurse
    - name: /etc/sensu/conf.d-client
    - source: salt://sensu/conf.d
    - user: root
    - file_mode: '0755'
{% endif %}

{% if grains['id'] == 'ftp' %}
httpd:
  pkg.installed:
    - pkg: httpd
  service.running:
    - name: httpd
    - enable: True
{% endif %}
