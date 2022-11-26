netstat:
  pkg.installed:
    - name: {{ pillar['net-tools'] }}