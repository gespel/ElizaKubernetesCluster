provider "helm" {
    kubernetes {
      config_path = "/etc/rancher/k3s/k3s.yaml"
    }
}

provider "kubernetes" {
  config_path = "/etc/rancher/k3s/k3s.yaml"
}

resource "kubernetes_manifest" "ingress" {
  manifest = yamldecode(file("${path.module}/ingress.yaml"))
}

resource "helm_release" "prometheus_operator" {
  name       = "kube-prometheus-stack"
  namespace  = "default"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"

  set {
    name  = "grafana.grafana.ini.server.root_url"
    value = "%(protocol)s://%(domain)s:%(http_port)s/grafana/"
  }

  set {
    name  = "grafana.grafana.ini.server.serve_from_sub_path"
    value = "true"
  }

  set {
    name  = "prometheusOperator.enabled"
    value = "true"
  }

  set {
    name  = "kubePrometheusStack.grafana.enabled"
    value = "true"
  }

  set {
    name  = "kubePrometheusStack.alertmanager.enabled"
    value = "true"
  }

  set {
    name  = "kubePrometheusStack.prometheus.enabled"
    value = "true"
  }

  set {
    name  = "service.type"
    value = "NodePort"
  }
}

module "reverse_proxy" {
  source = "./reverse-proxy"
}

module "dashboard" {
  source = "./dashboard"
}

module "seasy" {
  source = "./applications"
}