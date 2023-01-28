push:
 local.state.single:
 - tgt: test
 - args:
 - fun: file.managed
 - name: /var/lib/node_exporter/textfile_collector/salt_highstate.prom
 - makedirs: True
 - mode: 0664
 - contents: Cool