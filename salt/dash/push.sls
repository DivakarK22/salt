push:
 local.state.single:
 - tgt: salt
 - args:
 - fun: file.managed
 - name: /var/lib/node_exporter/textfile_collector/salt_highstate.prom
 - makedirs: True
 - mode: 0664
 - contents: |
 # HELP salt_highstate_status to check Salt highstate run status. If value is 1 then highstate is getting failed.
 # TYPE salt_highstate_status gauge
 salt_highstate_status
 salt_highstate_timestamp 
 salt_highstate_total 
 salt_highstate_jid 