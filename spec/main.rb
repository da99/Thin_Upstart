
require File.expand_path('spec/helper')
require 'Thin_Upstart'
require 'Bacon_Colored'
require 'pry'
require 'Exit_Zero'

D = "/tmp/Thin_Upstart"

def Multi_0 str
  str.strip.split("\n").each { |o|
    next if o.strip.empty?
    Exit_Zero o
  }
end

def recreate
  Multi_0 %@
    rm -rf #{D}
    mkdir #{D}
    
    mkdir #{D}/upstart
    mkdir #{D}/templates
    
    mkdir -p #{D}/apps/Hi
    mkdir -p #{D}/apps/Hi/config
    touch    #{D}/apps/Hi/thin.yml
    touch    #{D}/apps/Hi/config/my.yml
    

    mkdir -p #{D}/apps/Hello
    mkdir -p #{D}/apps/Hello/config
    touch    #{D}/apps/Hello/config/my.yml
    touch    #{D}/apps/Hello/thin.yml

    mkdir -p #{D}/templates
    cp -r spec/templates #{D}/
    @
end

recreate

def reset
  Multi_0 %!
    rm -rf #{D}/upstart
    mkdir  #{D}/upstart
  !
end

def chdir
  Dir.chdir(D) { yield }
end

def bin args
  chdir {
    Exit_Zero "Thin_Upstart #{args}"
  }
end

module Bacon
  class Context
    
    def should_mustache name, val, file = nil
      file ||= "upstart/#{@name}-Hi.conf"
      target = %r!#{name}: #{val}$!
      File.read(file)[target].should.match target
    end

    def generate name
      chdir {
        @name = name
        generate!(name) unless File.file?("upstart/#{@name}.conf")
      }
    end

    def generate! name
      @name = name
      chdir { 
        reset
        Thin_Upstart { |o| o.name @name }
      }
    end
    
    
    
  end # === Context
end # === Bacon

# ======== Include the tests.
if ARGV.size > 1 && ARGV[1, ARGV.size - 1].detect { |a| File.exists?(a) }
  # Do nothing. Bacon grabs the file.
else
  Dir.glob('spec/tests/*.rb').each { |file|
    require File.expand_path(file.sub('.rb', '')) if File.file?(file)
  }
end
