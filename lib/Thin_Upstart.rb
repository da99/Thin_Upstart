require 'Thin_Upstart/version'
require 'Exit_Zero'
require 'mustache'

Mustache.raise_on_context_miss = true

def Thin_Upstart
  o = Thin_Upstart.new
  yield o
  o.write
end

class Thin_Upstart
  
  module Class_Methods
    
    def trash dir
      cmd = `which trash`.strip.empty? || File.directory?("/tmp/Thin_Upstart") ? "rm" : "trash"
      files = []
      Dir.glob(File.join(dir, "*.conf")).each { |file|
        next unless File.read(file)["# Generated by Thin_Upstart"]
        files << file
        Exit_Zero "#{cmd} #{file}"
      }

      files.sort
    end
    
  end # === Class_Methods

  extend Class_Methods

  def initialize
    name      "My-Apps"
    apps      "./apps"
    templates "./templates/*.conf"
    output    "./upstart"
    yml       "thin.yml"
    kv        Hash[]
    yield(self) if block_given?
  end

  def remove_last_slash h
    new_h = Hash[]
    h.each { |k, v|
      new_h[k] = v.sub(%r!\//Z!, '')
    }
  end

  def write
    app_list = []
    dirs = Dir.glob(File.join apps, "/*")
    
    final = []
    
    tmpls = Dir.glob(templates)
    raise ArgumentError, "No templates found in: #{templates}" if tmpls.empty?
    
    dirs.each { |raw_app|
      app      = File.basename(raw_app)
      app_path = File.expand_path(raw_app)
      

      yml_path = Dir.glob(File.join app_path, yml).first
      next unless yml_path
      app_list << app
    
      yml = yml_path.sub( File.join(app_path, '/'), '')

      vals = remove_last_slash Hash[ 
        :name => name, 
        :app  => app, 
        :app_path => app_path, 
        :yml  => yml,
        :yml_path => yml_path,
        :apps_dir => File.expand_path(apps)
      ].merge(kv || {} )
      
      tmpls.each { |file|
        temp_path = Mustache.render(file, vals)
        file_name = File.basename(temp_path)
        final_path= File.join(output, file_name)
        tmpl_content = "# Generated by Thin_Upstart (Ruby gem)\n" + File.read(file)
        content   = Mustache.render(tmpl_content, vals)
        
        File.write( final_path, content )
        final << final_path
      }
      
    }

    raise(ArgumentError, "No apps found in: #{apps}") if app_list.empty?

    final.uniq.sort
  end

  def set_or_get attr, val = :RETURN
    if val == :RETURN
      instance_variable_get(:"@#{attr}")
    else
      instance_variable_set(:"@#{attr}", val)
    end
  end

  %w{ name yml kv }.each { |attr|
  
    eval %~
      def #{attr} *args
        set_or_get :#{attr}, *args
      end
    ~
    
  }

  %w{ apps templates output }.each { |attr|
  
    eval %~
      def #{attr} val = :RETURN
        if val == :RETURN
          set_or_get :#{attr}
        else
          set_or_get :#{attr}, File.expand_path(val)
        end
      end
    ~

  }
  
  
end # === class Thin_Upstart
