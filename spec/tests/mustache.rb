
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


