base:
{% if grains['os'] == 'CentOS' %}
  '*':
    - fstab
    - ncdu
    - htop
    - hostname-file
    - repo
    - salt-minion
    - cockpit
    - netstat
    - ntp
    - sudoers
    - prometheus
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
  'osfamily:GNOME':
    - match: grain
    - chrome
{% else %}
  'windows':
    - hostname-file.windows
    - windows.vlc
    - windows.sensu
    - windows.vagrant
{% endif %}