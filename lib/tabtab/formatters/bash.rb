module TabTab::Formatter
  class Bash < Base
    def type
      'bash'
    end

    def format_cmd(tabtab, cmd_name)
      "complete -o default -C '#{tabtab}' #{cmd_name}"
    end

    def format_alias(tabtab, cmd_name, alias_name)
      "complete -o default -C '#{tabtab}' #{alias_name}"
    end
  end
end
