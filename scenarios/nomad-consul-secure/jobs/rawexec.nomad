job "socat-job" {
  datacenters = ["fiserv"]
  type        = "service"
  namespace   = "consul"

  group "socat-group" {
    count = 3

    consul {
      partition = "default"
      namespace = "consul"
    }

    network {
      port "tcp" {
        to  = 9494
      }
    }

    service {
      provider = "consul"
      name     = "socat"
      port     = "tcp"

      check {
        name     = "Consul TCP Health Check"
        type     = "tcp"
        port     = 9494
        interval = "10s"
        timeout  = "2s"
      }
    }



    task "socat-task" {
      driver = "raw_exec"

      config {
        command = "/usr/bin/socat"
        args    = ["TCP4-LISTEN:9494,fork", "TCP4:example.com:80"]
      }

      resources {
        cpu    = 500
        memory = 256
      }

      env {
        SOCAT_OPTS = "-d -d"
      }
    }
  }
}
