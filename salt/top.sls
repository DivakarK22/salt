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
    - sensors
  'os:(CentOS)':
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