
describe "Thin_Upstart create" do
  
  before { reset }
  
  it "creates main app file: upstart/{{name}}.conf" do
    chdir {
      Thin_Upstart { |o| o.name "My-Apps" }
      should_mustache "name", "My-Apps", "upstart/My-Apps.conf"
    }
  end

  it "creates app file for each file: upstart/{{name}}-{{app}}.conf" do
    chdir {
      Thin_Upstart { |o| o.name "My" }
      %w{ Hi Hello }.each { |n|
        should_mustache "app", n, "upstart/My-#{n}.conf"
      }
    }
  end

  it "raise ArgumentError if no templates are found." do
    chdir {
      lambda {
        Thin_Upstart { |o| o.templates "ignored" }
      }.should.raise(ArgumentError)
      .message.should.match %r!No templates found in: #{`pwd`.strip}/ignored!
    }
  end
  
  it "raises ArgumentError if no apps are found." do
    target = File.expand_path("#{D}/..") 
    chdir {
      lambda {
        Thin_Upstart { |o| 
          o.apps target
        }
      }.should.raise(ArgumentError)
      .message.should.match %r!No apps found in: #{target}!
    }
  end

  it "ignores app with no .yml file" do
    name = "Ignored"
    chdir {
      `mkdir apps/#{name}`
      Thin_Upstart
      Dir.glob("upstart/*").detect { |f| f[name] }
      .should ==  nil
    }
  end

end # === Thin_Upstart create

describe "Thin_Upstart Mustache values" do
  
  before { generate 'my-apps' }

  it "sets: {{name}}" do
    chdir { should_mustache 'name', "my-apps" }
  end

  it "sets: {{app}}" do
    chdir { should_mustache 'app', 'Hi' }
  end

  it "sets: {{app_path}}" do
    chdir { should_mustache 'app_path', File.expand_path("apps/Hi") }
  end

  it "sets: {{yml}}" do
    chdir { should_mustache 'yml', "thin.yml" }
  end

  it "sets: {{yml_path}}" do
    chdir { should_mustache 'yml_path', File.expand_path("apps/Hi/thin.yml") }
  end

  it "sets: {{apps_dir}}" do
    chdir { should_mustache 'apps_dir', File.expand_path("./apps") }
  end
  
end # === Thin_Upstart Mustache values


