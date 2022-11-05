docker:
  file:
    - recurse
    - name: /etc/yum.repos.d
    - source: salt://docker/repo/
    - user: root
    - file_mode: '0755'
  pkg:
    - installed
    - pkgs: 
       - docker-ce 
       - docker-ce-cli
       - containerd.io 
       - docker-compose-plugin
  service:
    - running
    - name: docker
    - enable: True