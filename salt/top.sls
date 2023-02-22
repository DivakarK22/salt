base:
  '*':
    - ncdu
    - htop
    - hostname-file
    - repo
    - salt-minion
    - ruby
    - netstat
    - ntp
    - configs
    - sudoers
  'os:(RedHat|CentOS)':
    - match: grain
    - common.centos
  'os:Ubuntu':
    - common.ubuntu	
  'ansible':
    - ansible
    - docker
  'docker':
    - docker
    - kubeadm
  'grafana':
    - prometheus
    - grafana
  'salt':
    - salt-master