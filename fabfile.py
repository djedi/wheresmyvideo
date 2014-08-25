import os

from fabric.api import *


SOURCE_ROOT = '~/wheresmyvideo'
GRUNT_DIR = os.path.join(SOURCE_ROOT, 'simplify/simplify')

env.hosts = ['ubuntu@wheresmyvideo.com']


def deploy():
    pull()
    grunt_build()


def pull():
    with cd(SOURCE_ROOT):
        run('git pull -r')


def grunt_build():
    with cd(GRUNT_DIR):
        run('grunt build')