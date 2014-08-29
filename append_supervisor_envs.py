f = open('server/gunicorn.conf')
gunicorn_conf = f.read()
f.close()

f = open('../environment')
envs = f.read()
f.close()
envs = envs.replace('\n', ',')

f = open('/etc/supervisor/conf.d/gunicorn.conf', 'w')
f.write(gunicorn_conf)
f.write('\n')
f.write('environment = {}'.format(envs))
f.close()