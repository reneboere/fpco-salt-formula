!!python/unicode 'base':
  ubuntu-xenial:
  - ufw
  - ufw.default_deny
  - ufw.enable
  - ufw.allow_ssh
  - reclass
  - pkg
  - python.pip
  - apps.common
  - aws.cli.install
  - crontab.envvars
  - docker
  - dnsmasq
  - sysdig
  - salt.minion.install
  - salt.minion
  - ntp
  - consul.install
  - nomad.install
  - vault.install
  - consul.dnsmasq
  - consul.service
  - consul.template-tool
  - nomad.service.client-server
  - nomad.ufw
  - vault.service
  - stack.docker_cleanup
  - docker.install-from-image
  - git.repos

