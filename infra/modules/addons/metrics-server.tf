resource "helm_release" "metrics_server" {

  name             = "metrics-server"

  repository       = "https://kubernetes-sigs.github.io/metrics-server"

  chart            = "metrics-server"

  namespace         = "kube-system"

  create_namespace = false

  version = "3.13.0"

  wait = true

  timeout = 600

  atomic = true

  cleanup_on_fail = true

  set {

    name = "args[0]"

    value = "--kubelet-insecure-tls"

  }

  set {

    name = "args[1]"

    value = "--kubelet-preferred-address-types=InternalIP"

  }

}