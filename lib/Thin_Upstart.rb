require 'Thin_Upstart/version'
require 'Exit_Zero'
require 'mustache'

def Thin_Upstart
  o = Thin_Upstart.new
  yield o
  o.write
end

class Thin_Upstart
  
  def initialize
    name      "My-Apps"
    apps      "./apps"
    templates "./templates/*.conf"
    output    "./upstart"
    yml       "thin.yml"
  end

  def remove_last_slash h
    new_h = Hash[]
    h.each { |k, v|
      new_h[k] = v.sub(%r!\//Z!, '')
    }
  end

  def write
    Dir.glob(File.join apps, "/*").each { |raw_app|
      app      = File.basename(raw_app)
      app_path = File.expand_path(raw_app)
      

      yml_path = Dir.glob(File.join app_path, yml).first
      next unless yml_path
    
      yml = yml_path.sub( File.join(app_path, '/'), '')
      
      vals = remove_last_slash Hash[ 
        :name => name, 
        :app  => app, 
        :app_path => app_path, 
        :yml  => yml,
        :yml_path => yml_path,
        :apps_dir => File.expand_path(apps)
      ]
      
      tmpls = Dir.glob(templates)
      raise ArgumentError, "No templates found: #{templates}" if tmpls.empty?
      
      tmpls.each { |file|
        temp_path = Mustache.render(file, vals)
        file_name = File.basename(temp_path)
        final_path= File.join(output, file_name)
        content   = Mustache.render(File.read(file), vals)
        
        File.write( final_path, content )
      }
    }
  end

  def set_or_get attr, val = :RETURN
    if val == :RETURN
      instance_variable_get(:"@#{attr}")
    else
      instance_variable_set(:"@#{attr}", val)
    end
  end

  %w{ name yml }.each { |attr|
  
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
