import os

this_dir = os.path.dirname(os.path.abspath(__file__))
f1 = open(os.path.join(this_dir, 'server/gunicorn.conf'))
gunicorn_conf = f1.read()
f1.close()

f2 = open(os.path.join(os.path.dirname(this_dir), 'environment'))
envs = f2.read()
f2.close()
envs = envs.strip().replace('\n', ',')

f3 = open('/etc/supervisor/conf.d/gunicorn.conf', 'w')
f3.write(gunicorn_conf)
f3.write('environment = {}\n'.format(envs))
f3.close()