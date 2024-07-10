## Server Conffig
data_dir  = "/opt/hashicorp/nomad/data"
bind_addr = "0.0.0.0"
datacenter = "DATACENTER"

## set up logging
log_file = "/var/log/nomad/"  # service creates a log file under this dir
log_rotate_bytes = 1073741824  # 1GB
log_rotate_max_files = 1  # keep 1 additional file jic for troubleshooting
log_json = true
log_level = "INFO"

# Enable the server
server {
  enabled          = true
  bootstrap_expect = SERVER_COUNT
}

consul {
  address = "127.0.0.1:8500"
  token   = "CONSUL_TOKEN"
}

acl {
  enabled = true
}

vault {
  enabled          = false
  address          = "http://active.vault.service.consul:8200"
  task_token_ttl   = "1h"
  create_from_role = "nomad-cluster"
  token            = ""
}