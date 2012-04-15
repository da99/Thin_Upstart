
Thin\_Upstart
================

This is an alternative to [Foreman + Upstart](http://michaelvanrooijen.com/articles/2011/06/08-managing-and-monitoring-your-ruby-application-with-foreman-and-upstart/) 
generating your Upstart conf files. It ignores your Procfile,
and insteads uses your Thin .yml config file.  The following files
are generated (assuming you call your group of Thin apps 'web-app'):

    # App dirs
    |- app1
    |- app2

    # Template dirs
    |- {{name}}.conf
    |- {{name}}-{{app}}.conf

    # Files generated
    |- output-dir
      |- web-apps.conf
      |- web-apps-app1.conf
      |- web-apps-app2.conf
      |- ...


Installation
------------

    gem install Thin_Upstart

Usage: Ruby
------

    require "Thin_Upstart"
    
    Thin_Upstart { |o|
      o.name "web-apps"
      o.apps "./"
      o.templates "./templates"     
      o.output    "./output"        
      o.yml       "config/thin.yml" # file glob 
    }

Usage: Shell
------

    Thin_Upstart 
      --name       web-apps 
      --apps       ./ 
      --templates  ./templates
      --yml_glob   config/thin.yml
      --output     ./output
 
Run Tests
---------

    git clone git@github.com:da99/Thin_Upstart.git
    cd Thin_Upstart
    bundle update
    bundle exec bacon spec/main.rb

"I hate writing."
-----------------------------

If you know of existing software that makes the above redundant,
please tell me. The last thing I want to do is maintain code.

