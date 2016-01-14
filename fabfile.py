from fabric.api import env, local

def vagrant():
    env.user = 'vagrant'
    env.hosts = ['127.0.0.1:2222']
    result = local('vagrant ssh-config |grep IdentityFile', capture=True)
    env.key_filename = result.split()[1]

