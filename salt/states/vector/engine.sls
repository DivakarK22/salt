Install Vector engine:
  pip.installed:
    - name: saltext.vector
    - upgrade: true

Configure Vector engine:
  file.managed:
    - name: /etc/salt/master.d/vector-engine.conf
    - contents: |
        engines:
          - vector:
              address: "{{ salt['pillar.get']('vector_agent_endpoint', '127.0.0.1:9000') }}"
              exclude_tags:
                - salt/auth
                - minion_start
                - minion/refresh/*
                - "[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]"


Restart Salt master:
  cmd.run:
    - name: 'salt-call --local service.restart salt-master'
    - bg: true
    - onchanges:
      - pip: Install Vector engine
      - file: Configure Vector engine
