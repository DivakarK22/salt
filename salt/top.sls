base:
  '*':
    - vim
    - ncdu
    - htop
    - hostname-file
    - repo
    - salt-minion
    - sensu
    - ruby
  'ansible':
    - ansible
    - docker
  'docker':
    - docker
    - kubeadm
  'grafana':
    - prometheus
  'salt':
    - salt-master
  'k8':
    - docker
    - kubelet 
    - kubeadm 
    - kubectl