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
  'k8master':
    - docker
    - kubelet 
    - kubeadm 
    - kubectl