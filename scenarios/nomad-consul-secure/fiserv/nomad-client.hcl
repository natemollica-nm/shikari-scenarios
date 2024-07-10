data_dir   = "/opt/hashicorp/nomad/data"
bind_addr  = "0.0.0.0"
datacenter = "DATACENTER"

## set up logging
log_file             = "/var/log/nomad/"  # service creates a log file under this dir
log_rotate_bytes     = 1073741824  # 1GB
log_rotate_max_files = 1  # keep 1 additional file jic for troubleshooting
log_json             = true
log_level            = "INFO"

# Enable the client
client {
  enabled    = true
  node_class = "NODE_CLASS"
  options {
    "driver.raw_exec.enable"    = "1"
    "docker.privileged.enabled" = "true"
  }
}

# config.json will be populated by `gcloud auth configure-docker` cmd during bootstrap before nomad service restart
plugin "docker" {
  config {
    auth {
      config = "/root/.docker/config.json"
    }
    volumes {
      enabled = true
    }
    logging {
      type = "syslog"
      config = {
        syslog-address = "unixgram:///dev/log"
        tag = "docker/{{.Name}}"
      }
    }
  }
}

acl {
  enabled = true
}

telemetry {
  publish_allocation_metrics = true
  publish_node_metrics       = true
}

consul {
  address = "127.0.0.1:8500"
  token   = "CONSUL_TOKEN"
}

vault {
  enabled = true
  address = "http://active.vault.service.consul:8200"
}