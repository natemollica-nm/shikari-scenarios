job "httpd" {
  datacenters = ["fiserv"]
  type        = "service"
  namespace   = "default"
  group "httpd" {

    network {
      port "http" {}
    }

    consul {
      partition = "default"
      namespace = "consul"
    }

    service {
      provider = "consul"
      name     = "httpd"
      port     = "http"
    }

    task "httpd" {
      driver = "docker"

      config {
        image   = "busybox:1.36"
        command = "httpd"
        args    = ["-f", "-p", "${NOMAD_PORT_http}"]
        ports   = ["http"]
      }
    }
  }
}
