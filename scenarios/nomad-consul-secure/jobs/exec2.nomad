job "fiserv-exec" {
  group "fiserv-exec" {
    task "fiserv-exec" {
      driver = "exec2"
      config {
        command = "env"
      }
    }
  }
}