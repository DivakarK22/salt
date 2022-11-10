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
  'worker':
    - docker
  'worker2':
    - docker
  'worker3':
    - docker
  'gui':
    - terminator
    - libre
    - atom
    - nano
    - chrome
    - docker
  'cent1':
    - prometheus
  'salt':
    - salt-master
  'k8master':
    - docker
    - kubelet 
    - kubeadm 
    - kubectl