module TabTab::Formatter
end

Dir[File.dirname(__FILE__) + "/formatters/*.rb"].each do |path|
  require path.gsub(/.rb$/, '')
end