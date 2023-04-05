ruby:
  file:
    - recurse
    - name: /usr/local/rvm/rubies/
    - source: salt://sensu/ruby/
    - user: root
    - file_mode: '0755'