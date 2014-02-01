set :output, "/var/log/whenever.log"

every :hour do
  command "cd /var/www/wiki; env PATH=/usr/local/ruby-2.1.0/bin:$PATH bundle exec ruby /var/www/wiki/script/push_remote.rb"
end
