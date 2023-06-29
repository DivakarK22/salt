base:
{% if grains['os'] == 'CentOS' %}
  '*':
    - ncdu
    - htop
#    - hostname-file
    - repo
    - salt-minion
    - cockpit
    - netstat
    - ntp
    - sudoers
    - prometheus
    - common.centos
 #   - metricbeat
    - auditbeat
 #   - resolve
  'os:(RedHat|CentOS)':
    - match: grain
    - common.centos
  'os:Ubuntu':
    - common.ubuntu
  'ansible.root.com':
    - ansible
    - docker
  'docker.root.com':
   # - docker
    - kubeadm
  'grafana.root.com':
    - prometheus
    - grafana
  'salt.root.com':
    - salt-master
  'osfamily:GNOME':
    - match: grain
    - chrome
  'logstash.root.com':
    - elk.logstash
{% else %}
  'windows':
    - hostname-file.windows
    - windows.vlc
    - windows.sensu
    - windows.vagrant
{% endif %}