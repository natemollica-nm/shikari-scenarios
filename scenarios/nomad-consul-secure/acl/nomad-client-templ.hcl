agent_prefix "" {
  policy = "read"
}
namespace "default" {
  node_prefix "" {
    policy = "write"
  }
  service_prefix "" {
    policy = "write"
  }
  key_prefix "" {
    policy = "read"
  }
}