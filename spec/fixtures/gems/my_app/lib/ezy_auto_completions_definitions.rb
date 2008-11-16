EzyAutoCompletions::Definition.register('test_app') do |c|
  c.flags :help, :h, "help"
  c.flags :extra, :x
  c.command :unlock do |unlock|
    unlock.default do
      `git branch | sed -e "s/..//"`.split(/\n/) rescue []
    end
    unlock.flag :port, :p do
      port = 3000
      until `netstat -an | grep "^tcp" | grep #{port}`.strip.empty? || port > 3010
        port += 1
      end
      port > 3010 ? [] : [port.to_s]
    end
  end
  c.command :drink do
    %w[coke rum cola]
  end
  c.command :banana
end

EzyAutoCompletions::Definition.register('script/server') do |c|
  c.flag :binding, :b
  c.flag :daemon, :d
  c.flag :debugger, :x
  c.flag :help, :h
  # script/server -p TABTAB -> generated 3000, 30001
  c.flag :port, :p do
    port = 3000
    until `netstat -an | grep "^tcp" | grep #{port}`.strip.empty? || port > 3010
      port += 1
    end
    port > 3010 ? [] : [port]
  end
  c.flag :environment, :e do
    Dir['config/environments/*.rb'].map { |env| env.gsub(/^.*environments\//,'').gsub(/.rb$/,'') }
  end
end