job "cos-440aa49be229ce249df5722af03d9aa8d5808229" {
  region      = "global"
  namespace   = "default"
  datacenters = ["pdx60"]
  type        = "service"
  priority    = 50

  group "cos-440aa49be229ce249df5722af03d9aa8d5808229" {
    count = 3

    update {
      stagger             = "30s"
      max_parallel        = 1
      health_check        = "checks"
      min_healthy_time    = "10s"
      healthy_deadline    = "5m"
      progress_deadline   = "10m"
      auto_revert         = false
      auto_promote        = false
      canary              = 0
    }

    migrate {
      max_parallel      = 1
      health_check      = "checks"
      min_healthy_time  = "10s"
      healthy_deadline  = "5m"
    }

    constraint {
      attribute = "distinct_hosts"
      value     = true
    }

    constraint {
      attribute = "${node.class}"
      operator  = "="
      value     = "green"
    }

    restart {
      attempts      = 2
      interval      = "30m"
      delay         = "15s"
      mode          = "fail"
    }

    task "cos-440aa49be229ce249df5722af03d9aa8d5808229" {
      driver = "docker"

      config {
        image         = "gcr.io/clover-dev-container-registry/cos:440aa49be229ce249df5722af03d9aa8d5808229"
        volume_driver = "local"
        volumes       = ["cos_java_piddir:/tmp/hsperfdata_payweb"]
        ports         = ["http", "stats"]
      }

      service {
        name           = "cos-440aa49be229ce249df5722af03d9aa8d5808229-http-service"
        port           = "http"
        address_mode   = "auto"
        on_update      = "require_healthy"
        provider       = "consul"
        namespace      = "default"
        connect {
          native = false
        }

        check {
          name      = "cos-440aa49be229ce249df5722af03d9aa8d5808229-http-service-healthCheck"
          type      = "http"
          path      = "/adm/_status"
          interval  = "2s"
          timeout   = "2s"
          port      = "stats"
        }
      }

      template {
        destination = "secrets/secrets.env"
        embedded    = <<EOF
COS_STARTUP_PASSWORD=<Password>
EOF
        change_mode  = "restart"
        splay        = "5s"
        perms        = "0644"
      }

      constraint {
        attribute = "${attr.consul.version}"
        operator  = "semver"
        value     = ">= 1.8.0"
      }

      resources {
        cpu      = 5000
        memory   = 5000
      }

      log {
        max_files      = 10
        max_file_size  = 10
      }

      kill_timeout = "5s"

      network {
        port "stats" {
          static = 8999
        }
        port "http" {
          to     = 8020
        }
      }
    }

    ephemeral_disk {
      size = 300
    }

    reschedule {
      attempts       = 0
      delay          = "30s"
      delay_function = "exponential"
      max_delay      = "1h"
      unlimited      = true
    }

    consul {
      namespace = ""
      cluster   = "default"
      partition = ""
    }
  }
}
