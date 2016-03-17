from fabric.api import env, local, run, cd

code_dir = '/vagrant'
default_interpreter = '2.1.7'

def vagrant():
    env.user = 'vagrant'
    env.hosts = ['127.0.0.1:2222']
    result = local('vagrant ssh-config |grep IdentityFile', capture=True)
    env.key_filename = result.split()[1]

def install_ruby(version="latest"):
    if version is 'latest':
        run('rvm install ruby --latest')
    else:
        run('rvm install ruby %s' % version)

def create_gemset(name='stable', version=default_interpreter):
    run('rvm %s@blog-%s --create' % (version, name))

def delete_gemset(name='stable', version=default_interpreter):
    run('rvm %s do rvm --force gemset delete blog-%s' % (version, name))

#def use_gemset(name='stable', version=default_interpreter):
#    run('rvm use %s' % version)
#    run('rvm %s@blog-%s' % (version, name))

def build(release="stable"):
    with cd(code_dir):
        run('rvm @blog-%s do bundle install' % release)

def serve(drafts=False):
    with cd(code_dir):
        if drafts:
            run('bundle exec jekyll serve --force_polling --drafts')
        run('bundle exec jekyll serve --force_polling')

