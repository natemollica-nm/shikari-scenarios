# Allow read only access to the default namespace
namespace "default" {
  policy = "write"
}

agent {
  policy = "write"
}

operator {
  policy = "read"
}

plugin {
  policy = "write"
}

node {
  policy = "write"
}

quota {
  policy = "write"
}
