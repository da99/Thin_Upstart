
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
  
  it "sets custom values" do
    chdir { 
      Thin_Upstart { |o|
        o.name 'my-apps'
        o.templates 'templates/custom/*.conf'
        o.kv   :custom_1=>"1", :custom_2=>"2"
      }
      should_mustache 'custom_1', '1', "upstart/custom.conf"
      should_mustache 'custom_2', '2', "upstart/custom.conf"
    }
  end

  it "raises error if Mustache templates uses unknown value" do
    chdir { 
      lambda do
        Thin_Upstart { |o|
          o.name 'my-apps'
          o.templates 'templates/missing/*.conf'
        }
      end.should.raise(Mustache::ContextMiss)
      .message.should.match %r!Can't find custom_123 in !
    }
  end

end # === Thin_Upstart Mustache values


