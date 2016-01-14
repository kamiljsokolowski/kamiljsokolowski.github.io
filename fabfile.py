from fabric.api import env, local, run, cd

code_dir = '/vagrant'

def vagrant():
    env.user = 'vagrant'
    env.hosts = ['127.0.0.1:2222']
    result = local('vagrant ssh-config |grep IdentityFile', capture=True)
    env.key_filename = result.split()[1]

def build(release="stable"):
    run('rvm gemset use blog-%s' % release)
    with cd(code_dir):
        run('bundle install')

