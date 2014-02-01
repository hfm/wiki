#!/bin/sh

set -e
set -u
set -x

PATH=/usr/local/ruby-2.1.0/bin:$PATH
export PATH

/usr/local/ruby-2.1.0/bin/bundle exec unicorn -c /var/www/wiki/config/unicorn.rb -D
