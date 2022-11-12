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
  'gui':
    - terminator
    - libre
    - atom
    - nano
    - chrome
    - docker
  'grafana':
    - prometheus
  'salt':
    - salt-master
  'k8':
    - docker
    - kubelet 
    - kubeadm 
    - kubectl