////////////////////////////
// Nomad Job Specification
////////////////////////////
job "frontend-job" {
  datacenters = ["fiserv"] # Nomad Datacenter (defaults to DC1)
  type        = "service"  # Nomad job type
  namespace   = "default"  # Nomad Namespace for Job execution.

  ///////////////////
  // Nomad Task Group
  ///////////////////
  group "frontend-task-group" {
    count = 3 # Number of containers to deploy in Docker for Tasking

    //////////////////////////////////////
    // Consul Specific Configuration
    //////////////////////////////////////
    // Sets Consul Namespace of fake-service service registration.
    // Note: This configuration below also consists of the default Consul agent config
    //  discussed above.
    consul {
      partition = "default"
      namespace = "default"
    }

    //////////////////////////////////////
    // Nomad Job Network Configs
    //////////////////////////////////////
    // Nomad Job network configuration - sets fake-service port 1-to-1 mapping
    network {
      port "http" {
        to = 9090
      }
    }

    //////////////////////////////////////
    // Nomad Job Service Configs
    //////////////////////////////////////
    // Nomad Task Group Health Check (for all tasks) - checks fake-service /health
    //  endpoint.

    service {
      provider = "consul"
      name     = "frontend"
      port     = "http"

      //////////////////////////////////////
      // Nomad Job Service Health Checks
      //////////////////////////////////////
      check {
        name     = "Consul HTTP Health Check"
        type     = "http"
        path     = "/health"
        interval = "10s"
        timeout  = "2s"
      }
    }


    ///////////////////
    // Nomad Job Tasks
    ///////////////////
    // Configures Docker driver to pull/use container image.
    // Runs Docker entrypoint commands upon container run (args {} stanza)
    task "frontend-task" {
      driver = "docker"

      env {
        NAME        = "frontend-service"
        LISTEN_ADDR = "0.0.0.0:9090"
        MESSAGE     = "FRONTEND FRONTEND FRONTEND"
      }

      config {
        image   = "nicholasjackson/fake-service:v0.26.2"
        ports   = ["http"]
      }
    }
  }
}