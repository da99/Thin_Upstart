
describe "Thin_Upstart settings" do
  
  %w{ apps output }.each { |dir|
    it "removes ending slash of :#{dir}" do
      target = File.expand_path('.')
      o = Thin_Upstart.new
      o.apps "./#{dir}/"
      o.apps.should == "#{target}/#{dir}"
    end
  }
  
end # === Thin_Upstart settings
