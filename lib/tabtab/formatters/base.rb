class TabTab::Formatter::Base
  include TabTab::LocalConfig

  def initialize()
    @contents = []
  end

  protected

  def type
    nil
  end

  def format_cmd(tabtab, cmd_name)
    nil
  end

  def format_alias(tabtab, cmd_name, alias_name)
    nil
  end

  public

  def filename
    File.join(home, ".tabtab.#{type}")
  end

  def install_cmd(tabtab, cmd_name)
    @contents += format_cmd(tabtab, cmd_name).to_a
  end

  def install_alias(tabtab, cmd_name, alias_name)
    @contents += format_alias(tabtab, cmd_name, alias_name).to_a
  end

  def write
    file = File.open(filename, 'w')
    @contents.each { |line| file << "#{line}\n" }
    file.close
  end
end
