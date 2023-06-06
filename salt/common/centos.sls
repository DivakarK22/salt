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

{% if grains['id'] == 'ftp' %}
nfs_master:
  file:
    - recurse
    - name: /etc/
    - source: salt://nfs/exports/
    - user: root
    - file_mode: '0755'
{% else %}
fstab:
  cmd.run:
    - name: Update fstab
    - name: cp /etc/fstab $PWD && sudo sed  '/UUID/ i ftp:/nfs /nfs nfs defaults 0 0' $PWD/fstab > /etc/test &&  sudo uniq /etc/test /etc/fstab
    - check_cmd:
      - /bin/true
fstab_copy:
   cmd.run:
    - name: Update fstab
    - name: cp /etc/fstab $PWD && sudo sed  '/ftp/ i ftp:/usr/local/rvm /usr/local/rvm nfs defaults 0 0' $PWD/fstab > /etc/test &&  sudo uniq /etc/test /etc/fstab
    - check_cmd:
      - /bin/true
nfs-utils:
  pkg.installed:
    - pkg: nfs-utils
  cmd.run:
    - name: Create nfs dir
    - name: mkdir /nfs
    - check_cmd:
      - /bin/true
rvm_folder:
  cmd.run:
    - name: Create rvm dir
    - name: mkdir /usr/local/rvm
    - check_cmd:
      - /bin/true
rpcbind:
  service.running:
    - name: rpcbind
    - enable: True
nfs-server:
  service.running:
    - name: nfs-server
    - enable: True
nfs-lock:
  service.running:
    - name: nfs-lock
    - enable: True
nfs-idmap:
  service.running:
    - name: nfs-idmap
    - enable: True
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
            safe_mode: false
            name: {{ grains['id'] }}
            address: {{ grains['id'] }}
            subscriptions: [ "{{ grains['id'] }}" , "el7" ]
        socket:
            bind: 127.0.0.1
            port: 3030

sensu-server:
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
            safe_mode: false
            name: {{ grains['id'] }}
            address: {{ grains['id'] }}
            subscriptions: [ "{{ grains['id'] }}" , "el7" ]
        socket:
            bind: 127.0.0.1
            port: 3030
sensu-copy-client:
  file:
    - recurse
    - name: /etc/sensu/conf.d
    - source: salt://sensu/conf.d-client
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
