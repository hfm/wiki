require 'git'

path = File.join(File.dirname(__FILE__), "..")
repo = Git.open(path)
repo.push(repo.remote('origin'))
