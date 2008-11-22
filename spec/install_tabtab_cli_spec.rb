require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'install_tabtab/cli'

describe InstallTabTab::CLI, "with --development CLI flag" do
  before(:each) do
    ENV['HOME'] = '/tmp/some/home'
    dev_bin = File.expand_path(File.dirname(__FILE__) + "/../bin/tabtab")
    @cli = InstallTabTab::CLI.new
    Gem.expects(:all_load_paths).returns([])
    @cli.expects(:config).returns({"external" => %w[test_app]}).at_least(2)
    File.expects(:open).with('/tmp/some/home/.tabtab.bash', 'w').returns(mock do
      expects(:<<).with("complete -o default -C '#{dev_bin} --external' test_app\n")
      expects(:close)
    end)
    @stdout_io = StringIO.new
  end
  
  it "should point to local dev bin/tabtab instead of global tabtab CLI" do
    @cli.execute(@stdout_io, ['--development'])
  end
end

describe InstallTabTab::CLI, "with --external app flag" do
  before(:each) do
    ENV['HOME'] = '/tmp/some/home'
    @cli = InstallTabTab::CLI.new
    Gem.expects(:all_load_paths).returns([])
    @stdout_io = StringIO.new
  end
  
  it "should create a home file .tabtab.bash" do
    @cli.expects(:config).returns({"external" => %w[test_app]}).at_least(2)
    File.expects(:open).with('/tmp/some/home/.tabtab.bash', 'w').returns(mock do
      expects(:<<).with("complete -o default -C 'tabtab --external' test_app\n")
      expects(:close)
    end)
    @cli.execute(@stdout_io, [])
    @stdout_io.rewind
    @stdout = @stdout_io.read
  end

  it "should create a home file .tabtab.bash for alternate help flag" do
    @cli.expects(:config).returns({"external" => [{"-h" => "test_app"}]}).at_least(2)
    File.expects(:open).with('/tmp/some/home/.tabtab.bash', 'w').returns(mock do
      expects(:<<).with("complete -o default -C 'tabtab --external' test_app\n")
      expects(:close)
    end)
    @cli.execute(@stdout_io, [])
    @stdout_io.rewind
    @stdout = @stdout_io.read
  end

  it "should create a home file .tabtab.bash for an alias" do
    @cli.expects(:config).returns({"external" => %w[test], "alias" => { "test" => "test_app" }}).at_least(2)
    File.expects(:open).with('/tmp/some/home/.tabtab.bash', 'w').returns(mock do
      expects(:<<).with("complete -o default -C 'tabtab --external --alias test_app' test\n")
      expects(:close)
    end)
    @cli.execute(@stdout_io, [])
    @stdout_io.rewind
    @stdout = @stdout_io.read
  end

end

describe InstallTabTab::CLI, "with --gem GEM_NAME app flag" do
  before(:each) do
    @cli = InstallTabTab::CLI.new
    @cli.expects(:config).returns({}).at_least(1)
    Gem.expects(:all_load_paths).returns(['/gems/gem_with_tabtabs-1.0.0/lib'])
    Dir.expects(:[]).with('/gems/gem_with_tabtabs-1.0.0/lib/**/tabtab_definitions.rb').returns(['/gems/gem_with_tabtabs-1.0.0/lib/tabtab_definitions.rb'])
    File.expects(:read).with('/gems/gem_with_tabtabs-1.0.0/lib/tabtab_definitions.rb').returns(<<-EOS.gsub(/^      /,''))
    TabTab::Definition.register('tabtabbed_app') do |c|
      c.flags :help, :h, "help"
      c.flags :extra, :x
    end
    TabTab::Definition.register('another_app') do |c|
      c.flags :help, :h, "help"
      c.flags :extra, :x
    end
    EOS
    File.expects(:open).with('/tmp/some/home/.tabtab.bash', 'w').returns(mock do
      expects(:<<).with("complete -o default -C 'tabtab --gem gem_with_tabtabs' tabtabbed_app\n")
      expects(:<<).with("complete -o default -C 'tabtab --gem gem_with_tabtabs' another_app\n")
      expects(:close)
    end)
    @stdout_io = StringIO.new
    @cli.execute(@stdout_io, [])
    @stdout_io.rewind
    @stdout = @stdout_io.read
  end
  
  it "should create a home file .tabtab.bash" do
    # verify mocks
  end

end

describe InstallTabTab::CLI, "with --file FILE_NAME app flag" do
  before(:each) do
    ENV['HOME'] = '/tmp/some/home'
    @cli = InstallTabTab::CLI.new
    @cli.expects(:config).returns({'file' => {'/path/to/definition.rb' => 'some_app'}}).at_least(2)
    Gem.expects(:all_load_paths).returns([])
    File.expects(:open).with('/tmp/some/home/.tabtab.bash', 'w').returns(mock do
      expects(:<<).with("complete -o default -C 'tabtab --file /path/to/definition.rb' some_app\n")
      expects(:close)
    end)
    @stdout_io = StringIO.new
    @cli.execute(@stdout_io, [])
    @stdout_io.rewind
    @stdout = @stdout_io.read
  end
  
  it "should create a home file .tabtab.bash" do
    # verify mocks
  end

end

