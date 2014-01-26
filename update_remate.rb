require 'git'

repo = Git.init
repo.push(repo.remote('origin'))
