set :output, "/var/log/whenever.log"

every 1.minutes do
  command "/usr/local/ruby-2.1.0/bin/ruby /var/www/wiki/script/push_remote.rb"
end
