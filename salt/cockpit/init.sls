cockpit:
  pkg:
    - installed
    - pkgs: 
       - cockpit 
  service:
    - name: cockpit
    - enable: True
    - running