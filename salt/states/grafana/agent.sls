{% set version = '0.29.0' %}
{% set hash = '36736e7fb7707c9150e6c85f93337e25' %}

Fetch Grafana agent package:
  file.managed:
    - name: "/root/grafana-agent-{{ version }}-1.amd64.deb"
    - source: "https://github.com/grafana/agent/releases/download/v{{ version }}/grafana-agent-{{ version }}-1.amd64.deb"
    - source_hash: "{{ hash }}"

Install Grafana agent package:
  pkg.installed:
    - sources:
        - grafana-agent: /root/grafana-agent-{{ version }}-1.amd64.deb

Grafana agent user:
  user.present:
    - name: grafana-agent
    - system: true
    - home: /var/lib/grafana-agent
    - shell: /sbin/nologin
    - usergroup: true
    - groups:
        - root
    - createhome: false

Grafana agent config:
  file.managed:
    - name: /etc/grafana-agent.yaml
    - contents: |
        server:
          log_level: info
        metrics:
          wal_directory: /tmp/agent-wal
        traces:
          configs:
          - name: default
            remote_write:
              - endpoint: {{ salt['pillar.get']('grafana_tempo_endpoint', 'example.com:443') }}
                basic_auth:
                  username: {{ salt['pillar.get']('grafana_tempo_user', 'USER') }}
                  password: {{ salt['pillar.get']('grafana_tempo_pass', 'PASSWORD') }}
            receivers:
              # jaeger:
              #   protocols:
              #     grpc:
              #     thrift_binary:
              #     thrift_compact:
              #     thrift_http:
              # zipkin:
              otlp:
                protocols:
                  # http:
                  grpc:
              # opencensus:
        integrations:
          scrape_integrations: true
          agent:
            enabled: true
            scrape_integration: true
          node_exporter:
            enabled: true

Grafana agent service:
  service.running:
    - name: grafana-agent
    - enable: true
    - watch:
        - pkg: Install Grafana agent package
        - file: Grafana agent config
