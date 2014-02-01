APP_PATH = "./"

worker_processes 1
working_directory APP_PATH

listen "unix:#{APP_PATH}/sockets/unicorn.sock", :backlog => 1024

pid "/var/run/unicorn.pid"

stderr_path "/var/log/nginx/unicorn.stderr.log"
stdout_path "/var/log/nginx/unicorn.stdout.log"

preload_app true
check_client_connection false
