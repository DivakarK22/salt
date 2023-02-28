{% if grains['os'] == 'CentOS' %}
sensu:
  pkg.installed:
    - pkg: sensu
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
sensu-api:
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
    - name: /etc/sensu/conf.d
    - source: salt://sensu/conf.d-master
    - user: root
    - file_mode: '0755'
{% else %}
sensu-client:
  service.running:
    - name: sensu-client
    - enable: True
  file:
    - name: /etc/sensu/conf.d/client.json
    - file_mode: '0755'
    - serialize
    - user: sensu
    - group: sensu
    - makedirs: True
    - formatter: json
    - dataset:
        client:
            subscriptions: { grains['id'] }}
            safe_mode: false
            name: { grains['id'] }}
            address: { grains['id'] }}
            keepalive: {{ pillar['sensu']['keepalive'] }}
            notifications: {{ pillar['sensu']['notifications'] }}
{% endif %}

{% if grains['id'] == 'ftp' %}
httpd:
  pkg.installed:
    - pkg: httpd
  service.running:
    - name: httpd
    - enable: True
{% endif %}
