base:
  '*':
    - vim
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
  'os:(CentOS)':
    - common.centos
    - sensors
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
  # 'k8':
  # - docker
  # - kubelet 
  # - kubeadm 
  # - kubectl
  'www':
    - nginx
    - php.php-fpm
  'mysql':
    - mysql
  #'sensu-core':
  #  - sensu-core