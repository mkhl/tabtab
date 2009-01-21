module TabTab::Formatter
  class Zsh < Base
    def type
      'zsh'
    end

    def format_cmd(tabtab, cmd_name)
      [%Q[function #{function_name(cmd_name)} () { #{function_body(tabtab)} }],
       "compctl -K #{function_name(cmd_name)} #{cmd_name}"]
    end

    def format_alias(tabtab, cmd_name, alias_name)
      "compctl -K #{function_name(cmd_name)} #{alias_name}"
    end

    # I chose `__cmd` because `_cmd` clashes with the convention for new-style
    # autoloaded completion functions and we don't want to clobber those.
    def function_name(cmd_name)
      "__#{cmd_name}"
    end

    def function_body(tabtab)
      %Q[reply=(`#{tabtab} "$words[1]" "$words[-1]" "$words[-2]"`);]
    end
  end
end
