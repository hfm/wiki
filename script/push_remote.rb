require 'git'

PATH = File.join(File.dirname(__FILE__), "..")
repo = Git.open(PATH)
repo.push(repo.remote('origin'))
