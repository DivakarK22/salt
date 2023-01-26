{%- if data['fun'] == 'state.highstate' -%}
push_to_prometheus:
  local.state.single:
  - tgt: {{ data['id'] }}
  - args:
  - fun: file.managed
  - name: /var/lib/node_exporter/textfile_collector/salt_highstate.prom
  - makedirs: True
  - mode: 0664
  - contents: |
 # HELP salt_highstate_status to check Salt highstate run status. If value is 1 then highstate is getting failed.
 # TYPE salt_highstate_status gauge
  salt_highstate_status {{ data['retcode'] }}
  salt_highstate_timestamp {{ data['_stamp'] }}
  salt_highstate_total {{ data['return'] | length }}
  salt_highstate_jid {{ data['jid'] }}
{%- endif -%}