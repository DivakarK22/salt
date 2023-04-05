gems:
  file:
    - recurse
    - name: /usr/local/rvm/rubies/ruby-2.7.2/lib/ruby/gems/2.7.0/gems/
    - source: salt://sensu/gems/
    - user: root
    - file_mode: '0755'