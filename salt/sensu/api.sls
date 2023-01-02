include:
  - sensu
  - sensu.api_conf
  - sensu.rabbitmq_conf
  - sensu.redis_conf

sensu-api:
  service.running:
    - enable: True
    - require:
      - file: /etc/sensu/conf.d/api.json
      - file: /etc/sensu/conf.d/rabbitmq.json
      - file: /etc/sensu/conf.d/redis.json
    - watch:
      - file: /etc/sensu/conf.d/api.json
      - file: /etc/sensu/conf.d/rabbitmq.json
      - file: /etc/sensu/conf.d/redis.json
