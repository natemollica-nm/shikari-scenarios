job "cos" {
  region      = "global"
  namespace   = "default"
  datacenters = ["fiserv"]
  type        = "service"
  priority    = 50

  group "cos-group" {
    count = 3

    network {
      port "http" {
        to     = 9999
      }
    }

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

    restart {
      attempts      = 2
      interval      = "30m"
      delay         = "15s"
      mode          = "fail"
    }

    task "cos-task" {
      driver = "docker"

      env {
        NAME        = "cos"
        LISTEN_ADDR = "0.0.0.0:9999"
        MESSAGE     = "fiserv - cos test service"
      }

      config {
        image         = "nicholasjackson/fake-service:v0.26.2"
        ports         = ["http"]
      }

      service {
        name           = "cos-http-service"
        port           = "http"
        address_mode   = "auto"
        on_update      = "require_healthy"
        provider       = "consul"

        check {
          name      = "cos-http-service-healthCheck"
          type      = "http"
          path      = "/health"
          interval  = "2s"
          timeout   = "2s"
          port      = "http"
        }
      }

      kill_timeout = "5s"
    }

    reschedule {
      attempts       = 0
      delay          = "30s"
      delay_function = "exponential"
      max_delay      = "1h"
      unlimited      = true
    }

    consul {
      namespace = ""        ### Consul Namespace not here
      cluster   = "default"
      partition = ""        ### Consul Partition blank???
    }
  }
}
