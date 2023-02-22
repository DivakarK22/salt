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
  #'os:CentOS':
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
  'biosversion:090008':
    - common.centos