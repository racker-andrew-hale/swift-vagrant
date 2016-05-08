include:
  - common
  - common.supervisor

Django:
  pip.installed:
    - name: Django < 1.9
    - require:
      - sls: common

django-tagging:
  pip.installed:
    - name: django-tagging
    - require:
      - pip: Django

pytz:
  pip.installed:
    - name: pytz
    - require:
      - pip: django-tagging

service_identity:
  pip.installed:
    - name: service_identity
    - require:
      - pip: pytz

cairocffi:
  pip.installed:
    - name: cairocffi
    - require:
      - pip: service_identity

gunicorn:
  pip.installed:
    - name: gunicorn
    - require:
      - pip: cairocffi

whisper:
  pip.installed:
    - name: whisper
    - require:
      - pip: gunicorn

carbon:
  pip.installed:
    - name: carbon
    - require:
      - pip: whisper

graphite-web:
  pip.installed:
    - name: graphite-web
    - require:
      - pip: carbon

/opt/graphite/conf/carbon.conf:
  file.managed:
    - source: salt://opt/graphite/conf/carbon.conf.jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - pip: graphite-web

/opt/graphite/conf/graph-templates.conf:
  file.managed:
    - source: salt://opt/graphite/conf/graph-templates.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pip: graphite-web

/opt/graphite/conf/relay-rules.conf:
  file.managed:
    - source: salt://opt/graphite/conf/relay-rules.conf.jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - pip: graphite-web

/opt/graphite/conf/storage-schemas.conf:
  file.managed:
    - source: salt://opt/graphite/conf/storage-schemas.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pip: graphite-web

/opt/graphite/webapp/graphite/graphite_wsgi.py:
  file.symlink:
    - target: /opt/graphite/conf/graphite.wsgi.example
    - require:
      - pip: graphite-web

/opt/graphite/webapp/graphite/local_settings.py:
  file.managed:
    - source: salt://opt/graphite/webapp/graphite/local_settings.py.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - pip: graphite-web

initialize_sqlite:
  cmd:
    - run
    - name: python manage.py migrate --noinput
    - cwd: /opt/graphite/webapp/graphite/
    - require:
      - file: /opt/graphite/webapp/graphite/local_settings.py
    - unless:
      - cmd: test -f /opt/graphite/storage/graphite.db

/etc/supervisor/conf.d/graphiteweb.conf:
  file.managed:
    - source: salt://etc/supervisor/conf.d/conf.jinja
    - template: jinja
    - context:
      processname: graphiteweb
      command: gunicorn graphite_wsgi:application --bind 0.0.0.0:8888
      run_as: root
      autostart: true
      autorestart: true
      directory: /opt/graphite/webapp/graphite
    - require:
      - sls: common.supervisor
      - cmd: initialize_sqlite
  cmd.wait:
    - name: supervisorctl reload
    - watch:
      - file: /etc/supervisor/conf.d/graphiteweb.conf

/etc/supervisor/conf.d/carbon.conf:
  file.managed:
    - source: salt://etc/supervisor/conf.d/conf.jinja
    - template: jinja
    - context:
      processname: carbon
      command: python /opt/graphite/bin/carbon-cache.py --nodaemon --config=/opt/graphite/conf/storage-schemas.conf start
      run_as: root
      autostart: true
      autorestart: true
      directory: /opt/graphite
    - require:
      - sls: common.supervisor
      - file: /opt/graphite/conf/carbon.conf
  cmd.wait:
    - name: supervisorctl reload
    - watch:
      - file: /etc/supervisor/conf.d/carbon.conf
