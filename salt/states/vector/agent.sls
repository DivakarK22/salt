# To use the state, copy vector-engine/etc/vector.toml to states/vector/vector.toml
{% set version = '0.26.0' %}
{% set hash = 'c4ee30f31496110f9851a07c81757aa9' %}

Fetch Vector package:
  file.managed:
    - name: "/root/vector_{{ version }}-1_amd64.deb"
    - source: "https://packages.timber.io/vector/{{ version }}/vector_{{ version }}-1_amd64.deb"
    - source_hash: "{{ hash }}"

Install Vector package:
  pkg.installed:
    - sources:
        - vector: /root/vector_{{ version }}-1_amd64.deb

# The tpl file is here just to make the config replacements idempotent
Vector config template:
  file.managed:
    - name: /etc/vector/vector.toml.tpl
    - source: salt://{{ slspath }}/vector.toml

Vector config:
  file.copy:
    - name: /etc/vector/vector.toml
    - source: /etc/vector/vector.toml.tpl
    - force: true
    - onchanges:
        - file: Vector config template

# We do file.replace instead of file.managed here to be able to
# use the vector.toml in unit tests and also because it also has
# the native template syntax similar to Jinja
{% for pattern, repl in [
('127.0.0.1:9000', salt["pillar.get"]('vector_listen_source')),
('https://loki.example.com', salt["pillar.get"]('vector_loki_sink')),
('LOKI_USER', salt["pillar.get"]('vector_loki_user')),
('LOKI_PASS', salt["pillar.get"]('vector_loki_pass')),
('https://prom.example.com/api/prom/push', salt["pillar.get"]('vector_prom_sink')),
('PROM_USER', salt["pillar.get"]('vector_prom_user')),
('PROM_PASS', salt["pillar.get"]('vector_prom_pass')),
('http://127.0.0.1:8000/endpoint', salt["pillar.get"]('vector_http_sink')),
] %}
{% if repl %}
Vector replace {{ pattern }}:
  file.replace:
    - name: /etc/vector/vector.toml
    - pattern: '"{{ pattern }}"'
    - repl: '"{{ repl }}"'
    - watch_in:
        - service: Vector service
{% endif %}
{% endfor %}

Vector service:
  service.running:
    - name: vector
    - enable: true
    - watch:
        - pkg: Install Vector package
