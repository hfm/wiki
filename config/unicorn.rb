APP_PATH = "/var/www/wiki"

worker_processes 2
working_directory APP_PATH

listen "unix:/var/run/unicorn_wiki.sock", :backlog => 1024

pid "/var/run/unicorn.pid"

stderr_path "/var/log/unicorn/stderr.log"
stdout_path "/var/log/unicorn/stdout.log"

preload_app true
check_client_connection false
