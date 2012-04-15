
bins = Dir.glob("bin/*")

describe "permissions of bin/" do
  bins.each { |file|
    it "should chmod 755 for: #{file}" do
      `stat -c %a #{file}`.strip
      .should.be == "755"
    end
  }
end # === permissions of bin/

describe "bin: Thin_Upstart" do

  before { 
    chdir {
      reset
      `rm -r new-apps      2>&1`
      `rm -r new-templates 2>&1`
      `rm -r new-upstart   2>&1`
    }
  }

  it "accepts --name" do
    chdir {
      bin "--name MINE"
      should_mustache "name", "MINE", "upstart/MINE.conf"
    }
  end

  it "accepts --yml" do
    chdir {
      bin "--yml config/my.yml"
      should_mustache "yml", "config/my.yml", "upstart/My-Apps-Hi.conf"
    }
  end

  it "accepts --apps" do
    chdir {
      Exit_Zero "cp -r apps new-apps"
      bin "--apps new-apps"
      should_mustache "apps_dir", File.expand_path("new-apps"), "upstart/My-Apps-Hi.conf"
    }
  end

  it "accepts --templates" do
    chdir {
      Exit_Zero "cp -r templates new-templates"
      bin "--templates \"new-templates/*.conf\""
      should_mustache "app", "Hi", "upstart/My-Apps-Hi.conf"
    }
  end

  it "accepts --output" do
    chdir {
      Exit_Zero "mkdir new-upstart"
      bin "--output new-upstart"
      should_mustache "name", "My-Apps", "new-upstart/My-Apps-Hi.conf"
    }
  end
  
end # === bin: Thin_Upstart

describe "Thin_Upstart --trash dir" do
  
  it "it removes file from dir" do
    chdir {
      Multi_0 %@
        mkdir bin_trash
        echo "# Generated by Thin_Upstart (Ruby gem)" >> bin_trash/a.conf
        echo "# Generated by Thin_Upstart           " >> bin_trash/b.conf
        echo "# Generated by Thin"                    >> bin_trash/c.conf
      @

      bin "--trash bin_trash"
      File.file?("bin_trash/a.conf").should == false
      File.file?("bin_trash/b.conf").should == false
      File.file?("bin_trash/c.conf").should == true
    }
  end
  
end # === Thin_Upstart --trash dir


