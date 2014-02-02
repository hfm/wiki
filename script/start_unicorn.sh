#!/bin/sh

set -e
set -u
set -x

PATH=/usr/local/ruby-2.1.0/bin:$PATH
export PATH

WIKI_PATH=/var/www/wiki
cd $WIKI_PATH
bundle exec unicorn -c ${WIKI_PATH}/config/unicorn.rb -D
