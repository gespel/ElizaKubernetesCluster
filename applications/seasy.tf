resource "kubernetes_manifest" "seasy_deployment" {
  manifest = yamldecode(file("${path.module}/seasy-deployment.yaml"))
}

resource "kubernetes_manifest" "seasy_service" {
  manifest = yamldecode(file("${path.module}/seasy-service.yaml"))
}