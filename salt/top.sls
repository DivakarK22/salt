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
    - netstat
    - ntp
    - iptables
  'os:(RedHat|CentOS)':
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
  'salt':
    - salt-master
  'k8':
    - docker
    - kubelet 
    - kubeadm 
    - kubectl #testß
  'www':
    - nginx
    - php.php-fpm
  'mysql':
    - mysql
