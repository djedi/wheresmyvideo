import os

from fabric.api import *


SOURCE_ROOT = '/home/ubuntu/wheresmyvideo'
GRUNT_DIR = os.path.join(SOURCE_ROOT, 'simplify/simplify')
VIRTUALENV = '/home/ubuntu/.virtualenvs/wmv_env'
PYTHON = VIRTUALENV + '/bin/python'
PIP = VIRTUALENV + '/bin/pip'
MANAGE = SOURCE_ROOT + '/manage.py'
SETTINGS = '--settings=wheresmyvideo.settings.prod'

env.hosts = ['ubuntu@wheresmyvideo.com']


def deploy(*args):
    pull()
    if 'ux' in args or 'all' in args:
        grunt_build()
    if 'pip' in args or 'all' in args:
        pip_install()
    if 'migrate' in args or 'all' in args:
        migrate()
    if 'nginx' in args or 'all' in args:
        restart_nginx()
    if 'supervisor' in args or 'all' in args:
        restart_supervisor()
    if 'api' in args or 'all' in args:
        restart_gunicorn()


def pull():
    with cd(SOURCE_ROOT):
        run('git pull -r')


def grunt_build():
    with cd(GRUNT_DIR):
        run('grunt build')


def manage(command):
    run('{} {} {} {}'.format(PYTHON, MANAGE, command, SETTINGS))


def pip_install():
    with cd(SOURCE_ROOT):
        run('{} install -r requirements/prod.txt'.format(PIP))


def migrate():
    manage('migrate')


def restart_nginx():
    sudo('service nginx restart')


def restart_supervisor():
    sudo('service supervisor restart')


def restart_gunicorn():
    sudo('{} {}/append_supervisor_envs.py'.format(PYTHON, SOURCE_ROOT))
    sudo('supervisorctl restart gunicorn')
