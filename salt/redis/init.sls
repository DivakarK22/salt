redis:
  service:
    - running
    - require:
      - pkg: redis
  pkg:
    - installed
  file:
    - name: /etc/sensu/conf.d/client.json
    - file_mode: '0755'
    - serialize
    - user: sensu
    - group: sensu
    - makedirs: True
    - formatter: json
    - dataset:
        client:
            subscriptions: {{ id }}
            safe_mode: false
            name: {{ id }}
            address: {{ id }}
            keepalive: {{ pillar['sensu']['keepalive'] }}
            notifications: {{ pillar['sensu']['notifications'] }}