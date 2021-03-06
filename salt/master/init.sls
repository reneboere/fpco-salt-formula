{#- set the service as either running or disabled #}
{%- set status = salt['pillar.get']('salt:master:service:status', 'dead') %}
{#- boolean - if enabled, the service starts on boot #}
{%- set enabled = salt['pillar.get']('salt:master:service:enabled', False) %}
{#- include extra.conf, if there is pillar available #}
{%- set master_conf = salt['pillar.get']('salt:master:config', False) %}


salt-master:
  pkg.installed:
    - name: salt-master
  {%- if master_conf %}
  file.managed:
    - name: /etc/salt/master.d/extra.conf
    - contents_pillar: salt:master:config
    - allow_empty: True
    - watch_in:
        - service: salt-master
  {%- endif %}
  service:
    - {{ status }}
    - enable: {{ enabled }}
    - watch:
        - pkg: salt-master


{#- ensure the package has provided this file, else provide it if removed #}
salt_master-ufw_app_config:
  file.managed:
    - name: /etc/ufw/applications.d/salt.ufw
    - source: salt://salt/files/etc/ufw/applications.d/salt-master
    - user: root
    - group: root
    - mode: 0640


salt_master-ufw:
  cmd.run:
    - name: 'ufw allow salt'
    {#- ensure the ufw app config is present before this command runs #}
    - require:
        - file: salt_master-ufw_app_config
        - service: salt-master
