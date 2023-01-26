{% set user = salt['pillar.get']('tempo_relay_user', 'root') %}

Venv package:
  pkg.installed:
    - name: python3-virtualenv

Tempo relay venv:
  virtualenv.managed:
    - name: /home/{{ user }}/.tempo-relay
    - user: {{ user }}
    - runas: {{ user }}
    - venv_bin: /usr/bin/virtualenv
    - python: /usr/bin/python3
    - pip_upgrade: true
    - pip_pkgs:
      - salt-tempo-relay
      - flask==2.2.2
      - opentelemetry-api==1.14.0
      - opentelemetry-sdk==1.14.0
      - opentelemetry-exporter-otlp-proto-grpc==1.14.0

Tempo relay systemd unit:
  file.managed:
    - name: /etc/systemd/system/tempo-relay.service
    - contents: |
        [Unit]
        Description=Tempo Relay Service
        After=multi-user.target

        [Service]
        Type=simple
        Restart=on-failure
        Environment=PYTHONUNBUFFERED=1
        Environment=TEMPO_RELAY_ENDPOINT={{ salt['pillar.get']('tempo_relay_endpoint', 'http://localhost:4317') }}
        Environment=TEMPO_RELAY_SOCKET={{ salt['pillar.get']('tempo_relay_socket', '127.0.0.1:8000') }}
        ExecStart=/home/{{ user }}/.tempo-relay/bin/python3 /home/{{ user }}/.tempo-relay/bin/salt-tempo-relay
        User={{ user }}

        [Install]
        WantedBy=multi-user.target

Reload systemd for Tempo relay:
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
        - file: Tempo relay systemd unit

Tempo relay service:
  service.running:
    - name: tempo-relay
    - enable: true
    - watch:
        - cmd: Reload systemd for Tempo relay
        - file: Tempo relay systemd unit
        - virtualenv: Tempo relay venv
