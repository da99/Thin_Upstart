
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
      o.name      "web-apps"
      o.apps      "./apps"
      o.templates "./templates/*.conf" # file glob     
      o.output    "./upstart"        
      o.yml       "config/thin.yml"  
    }

Usage: Shell
------

    Thin_Upstart 
      --name       web-apps 
      --apps       ./apps
      --templates  ./templates
      --yml        config/thin.yml
      --output     ./output
      --help

*Note:* Be sure to use quotation marks when using file globs:

    Thin_Upstart --templates "template/*.conf"
    Thin_Upstart --yml       "config/*.yml"

Usage: Mustache Template
-----
In your Mustache templates, you have access to the following values:

* name:       Name of app group: e.g. My-Web-Apps
* apps\_dir:  Full path to directory of apps.
* app:        Name of current app: e.g. Blog
* app\_path:  Full path to app.
* yml:        Relative path from current app directory to .yml file
* yml\_path:  Full path to app directory.


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

