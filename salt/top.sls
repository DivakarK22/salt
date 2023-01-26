base:
  '*':
    - vim
    - ncdu
    - htop
    - hostname-file
    - repo
    - salt-minion
#    - sensu-agent
    - ruby
    - netstat
    - ntp
    - push_to_prometheus
    - sensu-client
    - configs
    - sudoers
    - sensors
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
    - grafana
  'salt':
    - salt-master
  'k8':
    - docker
    - kubelet 
    - kubeadm 
    - kubectl
  'www':
    - nginx
    - php.php-fpm
  'mysql':
    - mysql
  'sensu-core':
    - sensu-core