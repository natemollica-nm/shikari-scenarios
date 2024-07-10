## Client config
ui             = true
log_level      = "INFO"
data_dir       = "/opt/hashicorp/consul/data"
bind_addr      = "0.0.0.0"
client_addr    = "0.0.0.0"
advertise_addr = "IP_ADDRESS"
retry_join     = ["RETRY_JOIN"]
datacenter     = "DATACENTER"

## set up logging
log_file             = "/var/log/consul/"  # service creates a log file under this dir
log_rotate_bytes     = 1073741824  # 1GB
log_rotate_max_files = 1  # keep 1 additional file jic for troubleshooting
log_json             = true
log_level            = "INFO"
enable_syslog        = false

acl {
  enabled        = true
  default_policy = "deny"
  down_policy    = "extend-cache"

  # temporary addition. See: https://github.com/hashicorp/nomad/issues/16616
  tokens {
    default = "CONSUL_TOKEN"
  }
}

connect {
  enabled = true
}

ports {
  grpc = 8502
}