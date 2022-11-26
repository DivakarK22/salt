netstat:
  pkg.installed:
    - name: {{ pillar['netstat'] }}