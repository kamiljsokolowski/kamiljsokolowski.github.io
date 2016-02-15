---
layout: post
title:  "Manage Jekyll platform build environment with Vagrant, rvm & bundler"
date:   2016-02-15
description: Manage Jekyll platform build environment with Vagrant, rvm & bundler.
categories:
- blog
permalink: manage-jekyll-with-vagrant-rvm-bundler
---

Building static websites with Jekyll and Github Pages is a rather simple and straightforward process. but, when it comes to managing and maintaining the underlying Ruby environment and all its dependencies, things tend to get pretty messy from time to time (read: platform migration to Jekyll 3.0 which will be the subject of this post' continuation). Even more so if you decide to personalize a thing or two, introduce new feature(s) or implement a new, custom theme. The mess just keeps growing.

To get rid of the "pretty messy" part, we need to abstract the platform away from bare metal while making it:

1. Parallel.

    Bootstrap and manage multiple environments on a single machine while keeping them independent and isolated from each other so that i.e. changing between production and development website instances would not compromise one another.

2. Consistent.

    Setup. Modify. Break. Destroy. Repeat. Also track every change using version-controlled data files.

Provisioning on top of Vagrant and/or Docker machine seemed like the most obvious solution at first. After giving it some consideration, deploying an entire OS sandbox per each new branch would be to much overhead.

Coming from Python world, utilizing virtualenv for each new environment and storing all dependencies in a `requirements.txt` file would have been the easiest way to go. Fortunately enough Ruby ecosystem provides us with a similar solution called rvm.

### Provision a dedicated VM

Define additional dependencies inside a custom `bootstrap.sh` script:

{% highlight sh %}
sudo apt-get -y install nodejs git
{% endhighlight %}

Customize `Vagrantfile` to forward HTTP, HTTPS and Jekyll serve-dedicated ports (server is running headless) and use the `bootstrap.sh` during provisioning:

{% highlight ruby %}
Vagrant.configure(2) do |config|
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 443, host: 8443
  config.vm.network "forwarded_port", guest: 4000, host: 4000

  config.vm.provision "shell", path: "bootstrap.sh", privileged: false
end
{% endhighlight %}

And `vagrant up && vagrant ssh`..

### Setup rvm and configure gem sets

rvm is, concept-wise, similar to Python virtualenv. Simply put it lets you install, manage and work with multiple, completely independent Ruby environments (both interpreters and sets of gems) on a single host via `PATH` environmental variable manipulation.

Setup rvm (note: do not use `--ruby` option since it will always pull in the latest Ruby version):

{% highlight sh %}
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable
source /home/vagrant/.rvm/scripts/rvm
{% endhighlight %}

If the required interpreter version is not available as a pre-compiled binary (returned via the `known` option), rvm will build it from source:

{% highlight sh %}
rvm list known
rvm install 2.1.1
{% endhighlight %}

### Setup bundler

Managing gems with bundler introduces the necessary environment consistency. (yet again using Python reference) bundler `Gemfile` is to rvm environment what `requirements.txt` file is to virtualenv - a (version-controlled) list of required gems and their versions.

Add bundler to `global` gem set so that it will be included in ALL (current and future) environments.

{% highlight sh %}
rvm @global do gem install bundler
{% endhighlight %}

(note: gem sets are available on a per-interpreter basis)

### Setup Jekyll

In order to keep the build environment consistent, Github Pages engine dependencies and their versions must be stored in a `Gemfile`. While tracking all the requirements could become a serious effort, to make bootstrapping and maintenance easier, Github provides a single meta-gem - github-pages.

(as it will be version-controlled) create the `Gemfile` inside the project directory and customize it:

{% highlight ruby %}
source 'https://rubygems.org'
gem 'github-pages', '= 43'
{% endhighlight %}


Create a `blog-stable` gem set to store the stable version of the blog environment:

{% highlight sh %}
rvm gemset create blog-stable
rvm use 2.1.1@blog-stable --default
{% endhighlight %}

Install all the requirements:
{% highlight sh %}
rvm @blog-stable do bundle install
{% endhighlight %}

Before executing, any Jekyll-related command needs to be preceded with `rvm @<gemset> do bundle exec <cmd>` prefix.

To test our solution, run:
{% highlight sh %}
rvm @blog-stable do bundle exec jekyll serve
{% endhighlight %}

