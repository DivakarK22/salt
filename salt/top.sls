base:
{% if grains['os'] == 'CentOS' %}
  '*':
    - ncdu
    - htop
    - hostname-file
    - repo
    - salt-minion
  #  - ruby
    - netstat
    - ntp
    - nfs
    - sudoers
    - common.centos
  'os:(RedHat|CentOS)':
    - match: grain
    - common.centos
  'os:Ubuntu':
    - common.ubuntu	
  'ansible':
    - ansible
    - docker
  'docker':
   # - docker
    - kubeadm
  'grafana':
    - prometheus
    - grafana
  'salt':
    - salt-master
{% else %}
  'windows':
    - hostname-file.windows
    - windows.vlc
    - windows.sensu
    - windows.vagrant
{% endif %}